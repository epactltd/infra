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
