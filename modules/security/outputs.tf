output "public_alb_sg_id" {
  value = aws_security_group.public_alb.id
}

output "nuxt_sg_id" {
  value = aws_security_group.nuxt.id
}

output "internal_alb_sg_id" {
  value = aws_security_group.internal_alb.id
}

output "laravel_sg_id" {
  value = aws_security_group.laravel.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}
