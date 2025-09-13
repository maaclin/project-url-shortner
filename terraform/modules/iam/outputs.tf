
output "execution_role" {
    value = aws_iam_role.ecs_execution_role.arn
}
output "task_role" {
 value = aws_iam_role.ecs_task_role.arn
}

output "codedeploy_role" {
    value = aws_iam_role.codedeploy.arn
}