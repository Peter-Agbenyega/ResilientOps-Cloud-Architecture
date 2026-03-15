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

### Visual Architecture Diagram

See the architecture diagram below:

![ResilientOps Architecture Diagram](docs/diagrams/resilientops-architecture.md)

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
Database Subnets
```

This layered design separates internet-facing infrastructure from internal workloads and database-ready network space, improving security and operational resilience.

---

## Project Structure

```text
ResilientOps-Cloud-Architecture/
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
├── route53/
│   ├── route53.tf
│   ├── variables.tf
│   └── outputs.tf
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
└── README.md
```

The repository uses Terraform modules so that networking, compute, load balancing, and scaling logic can be maintained independently and reused more easily.

---

## Technologies Used

- Terraform
- Amazon Web Services (AWS)
- Git
- GitHub
- GitHub Actions
- Infrastructure as Code (IaC)

### AWS Services Represented

- VPC
- EC2
- Application Load Balancer
- Auto Scaling
- NAT Gateway
- Route Tables
- Security Groups
- Internet Gateway
- Route 53 module structure
- S3 and DynamoDB for Terraform remote state backend configuration

---

## Terraform Practices Demonstrated

### Modular Infrastructure Design

Infrastructure is split into reusable modules, including:

- `module "vpc"`
- `module "ec2"`
- `module "alb"`
- `module "auto_scaling"`
- `module "iam"`

This modular approach improves maintainability, supports reuse, and makes changes easier to review.

### Centralized Tagging Strategy

The project defines shared resource tags in [`locals.tf`](/Users/peterchristianagbenyega/Desktop/github-projects/ResilientOps-Cloud-Architecture/locals.tf), then merges optional extra tags for consistency across environments.

This supports governance, cost allocation, and cleaner resource management.

### Remote State Configuration

Terraform is configured to use an AWS S3 backend with DynamoDB state locking, which reflects a team-oriented workflow for safer infrastructure changes.

---

## CI Pipeline

This repository includes GitHub Actions workflows that validate Terraform changes as part of the DevOps workflow.

Validation steps include:

- `terraform fmt`
- `terraform validate`
- `terraform plan`

This helps catch formatting issues and configuration errors before deployment.

---

## Deployment Workflow

Typical local workflow:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=dev.ci.tfvars
terraform apply -var-file=dev.ci.tfvars
```

To avoid unnecessary AWS costs after testing:

```bash
terraform destroy -var-file=dev.ci.tfvars
```

Prerequisites:

- Terraform
- AWS CLI
- Git
- Configured AWS credentials

---

## DevOps Value

This project highlights practical DevOps and platform engineering habits:

- Infrastructure as Code with Terraform
- Reusable modular architecture
- Git-based change management
- CI-driven validation before deployment
- Environment-oriented configuration with tfvars
- Consistent tagging and infrastructure organization

It is designed as a portfolio-ready example of how cloud infrastructure can be structured for clarity, repeatability, and operational discipline.

---

## National Interest Relevance

Reliable and secure cloud infrastructure is foundational to modern digital services across public and private sectors.

This project demonstrates repeatable architecture patterns that help reduce misconfiguration risk, improve resilience, and support disciplined infrastructure delivery through automation and validation.

Its relevance is in showing how cloud environments can be built with stronger operational controls, clearer separation of responsibilities, and more dependable deployment workflows.

---

## Author

Peter Christian Agbenyega  
Cloud Security & DevSecOps Engineer

GitHub: <https://github.com/Peter-Agbenyega>
