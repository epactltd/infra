output "public_alb_dns_name" {
  value = aws_lb.public.dns_name
}

output "internal_alb_dns_name" {
  value = aws_lb.internal.dns_name
}

output "tenant_tg_arn" {
  value = aws_lb_target_group.tenant.arn
}

output "hq_tg_arn" {
  value = aws_lb_target_group.hq.arn
}

output "api_tg_arn" {
  value = aws_lb_target_group.api.arn
}

output "api_public_tg_arn" {
  value = aws_lb_target_group.api_public.arn
}

output "reverb_tg_arn" {
  value = aws_lb_target_group.reverb.arn
}
