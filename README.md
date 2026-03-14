# ResilientOps AWS Reference Architecture

## Executive Summary

ResilientOps AWS Reference Architecture is a portfolio-grade Terraform implementation of a secure, repeatable AWS application delivery pattern. The repository provisions a multi-tier VPC, controlled administrative access, an Application Load Balancer, and an autoscaling application tier using modular Terraform and a remote-state workflow designed for safer team operations.

This project is presented as a reusable reference architecture rather than a claim of production deployment. It is intended to demonstrate practical cloud engineering judgment, infrastructure automation, and secure-by-design thinking in a form that is clear to recruiters, hiring managers, and technical reviewers.

## Why This Project Matters

Modern cloud environments benefit from infrastructure that is:

- repeatable instead of manually assembled
- segmented instead of flat and overexposed
- reviewable in version control rather than changed only in the console
- scalable through grouped compute patterns instead of fixed single instances
- easier to operate through shared state, tagging, and CI-driven validation

This repository demonstrates capabilities relevant to resilient cloud operations, secure application delivery, and infrastructure modernization on AWS.

## Architecture Overview

### High-Level Flow

```text
Internet Users
      |
      v
Application Load Balancer
      |
  Auto Scaling Group
      |
      v
Application Instances

Administrative Access
      |
      v
Bastion Host
      |
      v
Private EC2 Hosts

Network Boundary
      |
      v
VPC with public, private, and database-ready subnets
```

### Network Layout

```text
AWS Account
└── VPC
    ├── Public Subnet AZ-1
    │   ├── Bastion Host
    │   └── NAT Gateway
    ├── Public Subnet AZ-2
    │   ├── Application Load Balancer
    │   ├── Auto Scaling Capacity
    │   └── NAT Gateway
    ├── Private Subnet AZ-1
    │   └── Private EC2 Host
    ├── Private Subnet AZ-2
    │   └── Private EC2 Host
    ├── Database Subnet AZ-1
    └── Database Subnet AZ-2
```

## Security Design Highlights

- Public, private, and database-ready subnet tiers establish clear network boundaries.
- A bastion host pattern provides a controlled administrative entry point instead of broad direct access to internal hosts.
- Security groups separate edge access, application traffic, and internal host access patterns.
- NAT Gateways support outbound connectivity for non-public tiers while keeping those tiers off the public internet.
- Remote Terraform state in S3 with DynamoDB locking supports safer multi-user workflows and reduces state collision risk.

Important implementation note:

- The repository includes genuine private hosts and database-ready subnets today.
- The autoscaling application tier is currently deployed in public subnets in the present implementation.
- That means the project demonstrates strong segmentation foundations, but it should not be described as a fully private application-tier deployment yet.

## Module Structure

| Module | Purpose |
| --- | --- |
| `vpc` | VPC, subnet tiers, route tables, Internet Gateway, and NAT Gateways |
| `ec2` | Bastion host, private EC2 hosts, and related security groups |
| `alb` | Application Load Balancer, ALB security group, listener, and target group |
| `auto-scaling` | Launch template, autoscaling group, and application server security group |
| `bootstrap` | Backend bootstrap resources for remote state and locking |

## Traffic Flow

1. Internet traffic reaches the Application Load Balancer in public subnets.
2. The ALB forwards requests to the autoscaling application tier.
3. Administrative SSH access is intended to enter through the bastion host rather than directly to private hosts.
4. Private EC2 instances remain reachable inside the VPC without direct public exposure.
5. NAT Gateways provide outbound internet access for private and database-ready subnet tiers where required.

## Remote State and Locking

The root module uses an S3 backend with DynamoDB state locking. This matters because remote state:

- keeps infrastructure state centralized
- reduces local-only drift between collaborators
- adds locking to prevent concurrent state corruption
- supports more professional review and deployment workflows

The backend bootstrap resources live in the separate `bootstrap/` directory because Terraform cannot create the backend it is already configured to use in the same run.

## CI/CD Workflow Summary

The GitHub Actions workflow is structured as a review-oriented Terraform pipeline:

- pull requests run formatting, validation, and plan
- pushes to `main` can run apply

This is a practical pattern for infrastructure teams because it separates review from execution and keeps changes visible before they are applied.

## Operational Value

This repository demonstrates:

- secure AWS network design
- controlled administrative access
- modular Terraform composition
- scalable application delivery through an autoscaling group
- infrastructure automation and reproducibility
- cloud operations maturity through remote state and CI checks

## Reusability and Extensibility

The project is intentionally modular so it can be extended without replacing the core foundation. Reasonable future enhancements include:

- moving the autoscaling application tier into private subnets behind the ALB
- tightening application security group ingress to the ALB security group only
- adding HTTPS termination with ACM when certificate prerequisites exist
- adding Route53 DNS integration when hosted zone prerequisites exist
- adding a database module to consume the existing database-ready subnet tier
- adding observability and secrets-management improvements

## Honest Current Limitations

- The autoscaling application tier is not yet private-only.
- The application server security group is broader than an ideal hardened ALB-only ingress model.
- HTTPS, Route53, and a database module are not enabled in the current root deployment.
- The application bootstrap process still relies on an external sample artifact download script.
- This repository is a reference architecture and portfolio project, not a claimed production deployment.

## Portfolio Relevance

This repository is structured to function as an evidence-ready technical portfolio artifact. It demonstrates infrastructure engineering patterns relevant to secure cloud operations, scalable application delivery, and repeatable platform workflows without overstating real-world deployment claims.

It should be understood as a technically honest reference architecture that showcases engineering capability, not as standalone proof of adoption, compliance certification, or legal eligibility outcome.

## How To Run

### Prerequisites

- Terraform `>= 1.6.0`
- AWS credentials for the target account
- Existing backend resources for the S3 state bucket and DynamoDB lock table
- A local `dev.tfvars` file created from `dev.tfvars.example`

### Workflow

```bash
terraform init -input=false
terraform workspace select dev || terraform workspace new dev
terraform fmt -recursive
terraform validate
terraform plan -input=false -var-file=dev.tfvars
terraform apply -input=false -var-file=dev.tfvars
```

## Inputs and Outputs Overview

Key inputs include:

- AWS region
- VPC and subnet CIDR ranges
- availability zones
- bastion access CIDR
- EC2 instance type and key pair
- autoscaling capacity settings
- common tags and optional extra tags

Key outputs include:

- VPC ID
- public and private subnet IDs
- bastion public IP
- ALB DNS name
- autoscaling group name

## Additional Notes

Supporting documentation is available in [`docs/architecture-overview.md`](./docs/architecture-overview.md), [`docs/security-considerations.md`](./docs/security-considerations.md), and [`docs/deployment-flow.md`](./docs/deployment-flow.md).
