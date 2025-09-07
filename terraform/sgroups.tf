
resource "aws_security_group" "endpoints_sg" {
  name_prefix = "${local.name}-vpc-endpoints"
  vpc_id      = aws_vpc.main.id
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
  vpc_id      = aws_vpc.main.id

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
    from_port   = 8080
    to_port     = 8080
    protocol    = var.tcp
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "${local.name}-ecs-sg"
  vpc_id = aws_vpc.main.id

  tags = { Name = "ecs-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  description                  = "Allow traffic from ALB"
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = var.tcp
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  description       = "Egress traffic temporary"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4       = var.allow
}