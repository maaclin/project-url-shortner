
# ECS v2

# URL Shortener Service - ECS v2 Project

## Project Overview

This repository contains a production-ready URL shortener service deployed on AWS ECS Fargate. 

## Architecture

The service is built with the following components:

- Containerised Python application running on ECS Fargate in private subnets
- Application Load Balancer with WAF protection
- DynamoDB for storing URL mappings (PAY_PER_REQUEST with PITR enabled)
- VPC Endpoints for secure, private connectivity (no NAT gateways)
- Canary deployment via AWS CodeDeploy
- GitHub Actions for CI/CD using OIDC authentication

## Infrastructure

All infrastructure is defined as code using Terraform, with state stored in S3 with native locking. The infrastructure includes:

### Networking

- VPC with public and private subnets
- Internet Gateway and route tables
- VPC Endpoints for S3, DynamoDB, ECR and CloudWatch Logs

### Security

- WAF with managed rule groups for protection
- Security groups with least privilege access
- IAM roles following principle of least privilege

### Compute & Storage

- ECS Cluster with Fargate launch type
- ECR repository for container images
- DynamoDB table for URL mappings

### Load Balancing & Deployment

- Application Load Balancer with HTTP to HTTPS redirection
- Blue/Green deployment strategy with CodeDeploy
- Automatic rollback on failed health checks

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

### CI Workflow

- Builds the application container
- Runs unit tests
- Scans the image for vulnerabilities
- Pushes the image to ECR on successful builds to the main branch

### CD Workflow

- Runs Terraform plan on pull requests
- Applies Terraform changes on merges to main
- Triggers CodeDeploy for canary deployments
- Uses OIDC for secure AWS authentication (no long-lived keys)

## API Endpoints

- `GET /healthz` - Health check endpoint returning `{"status":"ok"}`
- `POST /shorten` - Creates a short URL from a provided long URL
- `GET /{short}` - Redirects to the original long URL

## Design Decisions and Trade-offs

- Using VPC Endpoints instead of NAT Gateways?
Using VPC Endpoints comes with a steep learning curve but cost can dramatically drop as Gateway Endpoints are free and Interface Endpoints are charged per usaged opposed a hourly rate with NAT Gateway. 

- Canary deployment strategy?
A canary deployment strategy is widely used in production and aligns well with minimising the blast radius from potential bugs on deployment. This focus on rolling out changes slowly means only a small amount of end users could be affected on rollout. 

- Any security considerations?
Putting ALB increasing the security of the application as we will be federating which packets are entering our app instead of just using security groups.
Following the principle of least privilege when creating IAM roles and using OIDC to prevent long lived credentials being stored. 

- Cost optimisations made during implementation
Smaller more cost effective instance types, PITR on DynamoDB, Eliminating NAT by VPC endpoints and 

- Potential improvements or future enhancements

