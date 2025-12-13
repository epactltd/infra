# Public ALB
resource "aws_lb" "public" {
  name               = "${var.project_name}-${var.environment}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_logs_bucket == "" ? [] : [var.access_logs_bucket]
    content {
      bucket = access_logs.value
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-alb"
  }
}

resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tenant.arn
  }
}

resource "aws_lb_target_group" "tenant" {
  name                 = "${var.project_name}-${var.environment}-tenant-tg"
  port                 = 3000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_target_group" "hq" {
  name                 = "${var.project_name}-${var.environment}-hq-tg"
  port                 = 3000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_target_group" "reverb" {
  name                 = "${var.project_name}-${var.environment}-reverb-tg"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    matcher             = "200,404,426" # 404 = Reverb returns this on /, 426 = Upgrade Required (expected for WS)
  }

  # Sticky sessions for WebSocket connections
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "hq" {
  listener_arn = aws_lb_listener.public_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hq.arn
  }

  condition {
    host_header {
      values = [var.hq_host]
    }
  }
}

resource "aws_lb_listener_rule" "reverb" {
  listener_arn = aws_lb_listener.public_https.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reverb.arn
  }

  condition {
    host_header {
      values = [var.reverb_host]
    }
  }
}

# Public-facing API target group (separate from internal API TG)
resource "aws_lb_target_group" "api_public" {
  name                 = "${var.project_name}-${var.environment}-api-pub-tg"
  port                 = 8000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/up"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.public_https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_public.arn
  }

  condition {
    host_header {
      values = [var.api_host]
    }
  }
}

# Internal ALB
resource "aws_lb" "internal" {
  name               = "${var.project_name}-${var.environment}-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal_alb_sg_id]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = "${var.project_name}-${var.environment}-internal-alb"
  }
}

resource "aws_lb_target_group" "api" {
  name                 = "${var.project_name}-${var.environment}-api-tg"
  port                 = 8000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/up" # Laravel's default health endpoint
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_wafv2_web_acl_association" "public" {
  count        = var.web_acl_arn == "" ? 0 : 1
  resource_arn = aws_lb.public.arn
  web_acl_arn  = var.web_acl_arn
}
