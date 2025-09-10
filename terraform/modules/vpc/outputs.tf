output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_sub" {
    value = aws_subnet.public[*].id
}

output "private_sub" {
    value = aws_subnet.private[*].id
}

output "igw" {
    value = aws_internet_gateway.gw.id
}

output "ecr-dkr" {
    value = aws_vpc_endpoint.ecr-dkr-endpoint.arn
}

output "ecr-api" {
    value = aws_vpc_endpoint.ecr-api-endpoint.arn
}

output "cloudwatch" {
    value = aws_vpc_endpoint.cloudwatch.arn
}

output "dynamodb" {
    value = aws_vpc_endpoint.dynamodb.arn
}

output "s3" {
    value = aws_vpc_endpoint.s3.arn
}