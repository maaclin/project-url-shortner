output "table_name" {
    value = aws_dynamodb_table.url.name
}

output "cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service" {
    value = aws_ecs_service.ecs_service.name
}