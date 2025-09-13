output "endpoint_sg" {
  value = aws_security_group.endpoints_sg.id 
}

output "alb_sg" {
  value       = aws_security_group.alb.id
}

output "ecs_sg" {
  value       = aws_security_group.ecs_sg.id
}

output "vpc_endpoints" {
  description = "VPC Endpoints"
  value = {
    ecr_dkr    = aws_vpc_endpoint.ecr-dkr-endpoint.id
    ecr_api    = aws_vpc_endpoint.ecr-api-endpoint.id
    cloudwatch = aws_vpc_endpoint.cloudwatch.id
    dynamodb   = aws_vpc_endpoint.dynamodb.id
    s3         = aws_vpc_endpoint.s3.id
  }
}