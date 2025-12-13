output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "api_task_definition_arn" {
  value = aws_ecs_task_definition.api.arn
}

output "worker_task_definition_arn" {
  value = aws_ecs_task_definition.worker.arn
}

output "tenant_task_definition_arn" {
  value = aws_ecs_task_definition.tenant.arn
}

output "hq_task_definition_arn" {
  value = aws_ecs_task_definition.hq.arn
}

output "scheduler_task_definition_arn" {
  value = aws_ecs_task_definition.scheduler.arn
}

output "reverb_task_definition_arn" {
  value = aws_ecs_task_definition.reverb.arn
}

# Service Names (for CI/CD)
output "api_service_name" {
  value = aws_ecs_service.api.name
}

output "tenant_service_name" {
  value = aws_ecs_service.tenant.name
}

output "hq_service_name" {
  value = aws_ecs_service.hq.name
}

output "worker_service_name" {
  value = aws_ecs_service.worker.name
}

output "scheduler_service_name" {
  value = aws_ecs_service.scheduler.name
}

output "reverb_service_name" {
  value = aws_ecs_service.reverb.name
}
