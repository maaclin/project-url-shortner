

Plan - 

VPC - ✅
- 2 Public Subnets for ALB
- 2 Private Subnets
- IGW 
- Route Table (public + private)
- Route Table Assoc

VPC Endpoints - ✅

Gateway Endpoints - S3, DynamoDB
Interface Endpoints - ECR api,dkr and Cloudwatch Logs 

Security groups - 
- Security groups for HTTP/HTTPS (ALB) 
- ECS Tasks sg
- VPC endpoint security group 

ALB -

- ALB
- Target group for ECS blue and green
- Blue listeners - Http redirect and Https forward
- Acm certificate for domain attached at listener 
- WAF Rules on ALB -- (later)

ECS -
- ECS cluster
- CloudWatch Log group
- Task definition 

CodeDeploy - 
- Canary deployment

GitHub Actions workflows - 
- CI: build, image scan and push to ECR
- CD: terraform plan (PR), terraform apply (main) via OIDC
- codeploy?# project-url-shortner
