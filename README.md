# ResilientOps Cloud Architecture

Enterprise-grade AWS Infrastructure as Code reference architecture built using Terraform.

This project demonstrates how resilient cloud infrastructure environments are designed, automated, and validated using modern DevOps and Infrastructure-as-Code practices.

---

## Architecture Overview

ResilientOps provisions a secure, modular, and highly available AWS environment using Terraform.

The repository is structured to reflect common production-style infrastructure patterns where reliability, access control, and repeatable automation matter.

### Core Architecture Components

The infrastructure includes:

- Custom Amazon VPC
- Public subnets for internet-facing resources
- Private subnets for internal application workloads
- Dedicated database subnets for backend data tier placement
- Internet Gateway for public connectivity
- NAT Gateway support for controlled outbound access
- Route tables to manage traffic segmentation
- Bastion host EC2 instance for controlled administrative access
- Application Load Balancer for inbound traffic distribution
- Auto Scaling configuration for elastic compute capacity
- Security groups for network-level access control

Resources are distributed across multiple Availability Zones to improve resilience and reduce the impact of single-zone failures.

---

## Architecture Flow

```text
Internet
   |
   v
Internet Gateway
   |
   v
Application Load Balancer
   |
   v
Auto Scaling Group
   |
   v
Application EC2 Instances
   |
   v
Database SubnetsArchitecture DiagramThis layered design separates internet-facing infrastructure from internal workloads and database-ready network space, improving security and operational resilience.

⸻

Additional Documentation

See detailed architecture notes here:

ResilientOps Architecture Notes￼

⸻

Project StructureResilientOps-Cloud-Architecture/
├── vpc/
│   ├── vpc.tf
│   ├── variables.tf
│   └── outputs.tf
├── ec2/
│   ├── ec2.tf
│   ├── variables.tf
│   └── outputs.tf
├── alb/
│   ├── alb.tf
│   ├── variables.tf
│   └── outputs.tf
├── auto-scaling/
│   ├── auto-scaling.tf
│   ├── variables.tf
│   └── outputs.tf
├── iam/
│   ├── iam.tf
│   ├── variables.tf
│   └── outputs.tf
├── route53/
│   ├── route53.tf
│   ├── variables.tf
│   └── outputs.tf
├── docs/
│   ├── architecture/
│   │   └── resilientops-architecture.md
│   └── diagrams/
│       └── resilientops-architecture.png
├── bootstrap/
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       ├── terraform-destroy.yml
│       └── terraform.yml
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── dev.ci.tfvars
└── README.mdThe repository uses Terraform modules so that networking, compute, load balancing, and scaling logic can be maintained independently and reused more easily.

⸻

Technologies Used
	•	Terraform
	•	Amazon Web Services (AWS)
	•	Git
	•	GitHub
	•	GitHub Actions
	•	Infrastructure as Code (IaC)

AWS Services Represented
	•	VPC
	•	EC2
	•	Application Load Balancer
	•	Auto Scaling
	•	NAT Gateway
	•	Route Tables
	•	Security Groups
	•	Internet Gateway
	•	Route 53 module structure
	•	S3 and DynamoDB for Terraform remote state backend configuration

⸻

Terraform Practices Demonstrated

Modular Infrastructure Design

Infrastructure is split into reusable modules, including:
	•	module "vpc"
	•	module "ec2"
	•	module "alb"
	•	module "auto_scaling"
	•	module "iam"

This modular approach improves maintainability, supports reuse, and makes changes easier to review.

Centralized Tagging Strategy

The project defines shared resource tags in locals.tf￼, then merges optional extra tags for consistency across environments.

This supports governance, cost allocation, and cleaner resource management.

Remote State Configuration

Terraform is configured to use an AWS S3 backend with DynamoDB state locking, which reflects a team-oriented workflow for safer infrastructure changes.

⸻

Design Decisions

Why Public and Private Subnets

Public subnets are used for infrastructure that must receive internet traffic, while private subnets are used for internal workloads that should not be directly exposed. This separation improves security and follows common cloud architecture practices.

Why an Application Load Balancer

The Application Load Balancer provides a controlled entry point for inbound traffic and supports distribution of requests across application instances. This improves availability and supports future scaling.

Why Auto Scaling

Auto Scaling helps the architecture respond to workload changes by increasing or decreasing compute capacity as needed. This supports resilience and efficient infrastructure use.

Why a Bastion Host

The bastion host provides controlled administrative access to internal compute resources. This reduces the need to expose private instances directly to the internet.

⸻

CI Pipeline

This repository includes GitHub Actions workflows that validate Terraform changes as part of the DevOps workflow.

Validation steps include:
	•	terraform fmt
	•	terraform validate
	•	terraform plan

This helps catch formatting issues and configuration errors before deployment.

⸻

Deployment Workflow

Typical local workflow:terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=dev.ci.tfvars
terraform apply -var-file=dev.ci.tfvarsTo avoid unnecessary AWS costs after testing:terraform destroy -var-file=dev.ci.tfvarsPrerequisites:
	•	Terraform
	•	AWS CLI
	•	Git
	•	Configured AWS credentials

⸻

Verification Commands

Check EC2 instances:aws ec2 describe-instances --region us-east-1Check NAT Gateways:aws ec2 describe-nat-gateways --region us-east-1Check VPCs:aws ec2 describe-vpcs --region us-east-1DevOps Value

This project highlights practical DevOps and platform engineering habits:
	•	Infrastructure as Code with Terraform
	•	Reusable modular architecture
	•	Git-based change management
	•	CI-driven validation before deployment
	•	Environment-oriented configuration with tfvars
	•	Consistent tagging and infrastructure organization

It is designed as a portfolio-ready example of how cloud infrastructure can be structured for clarity, repeatability, and operational discipline.

⸻

National Interest Relevance

Reliable and secure cloud infrastructure is foundational to modern digital services across public and private sectors.

This project demonstrates repeatable architecture patterns that help reduce misconfiguration risk, improve resilience, and support disciplined infrastructure delivery through automation and validation.

Its relevance is in showing how cloud environments can be built with stronger operational controls, clearer separation of responsibilities, and more dependable deployment workflows.

⸻

Author

Peter Christian Agbenyega
Cloud Security & DevSecOps Engineer

GitHub: https://github.com/Peter-Agbenyega￼
