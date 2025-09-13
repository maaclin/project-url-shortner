
locals {
  name = "ecs-v2"
  region = "eu-west-2"
}

resource "aws_security_group" "endpoints_sg" {
  name_prefix = "${local.name}-vpc-endpoints"
  vpc_id      = var.vpc_id
  description = "Security group for VPC endpoints"

  # ssl termination occurs from outside traffic; endpoint traffic is forwarded on https
  ingress {
    description     = "Incoming traffic from ECS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Outgoing traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allow]
  }

  tags = { Name = "${local.name}-vpc-endpoints-sg" }
}

resource "aws_security_group" "alb" {
  name        = "${local.name}-alb-sg"
  description = "ALB SG allow incoming HTTPS/HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.http
    to_port     = var.http
    protocol    = var.tcp
    cidr_blocks = [var.allow]
  }
  ingress {
    from_port   = var.https
    to_port     = var.https
    protocol    = var.tcp
    cidr_blocks = [var.allow]
  }

  ## traffic to and from our app 

  egress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = var.tcp
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "${local.name}-ecs-sg"
  vpc_id = var.vpc_id

  tags = { Name = "ecs-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  description                  = "Allow traffic from ALB"
  from_port                    = var.app_port
  to_port                      = var.app_port 
  ip_protocol                  = var.tcp
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb.id 
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  description       = "Egress traffic temporary"
  ip_protocol       = "-1"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = var.allow
}

// Endpoints

resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = var.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  subnet_ids          = var.private_subnets

}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  subnet_ids          = var.private_subnets
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${local.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnets
  security_group_ids  = [aws_security_group.endpoints_sg.id]
} 


resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_rt]

  tags = { Name = "${local.name}-dynamodb" }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_rt]

  tags = { Name = "${local.name}-s3" }

}