# ResilientOps Cloud Architecture

## Overview

ResilientOps Cloud Architecture is an Infrastructure as Code (IaC) project that provisions a secure and resilient AWS networking environment using Terraform.

The project demonstrates enterprise-grade DevOps practices including modular Terraform design, tagging strategy, environment separation, and CI pipeline validation using GitHub Actions.

This repository simulates how cloud infrastructure is deployed and managed in real DevOps teams.

---

## Architecture

The infrastructure provisions a resilient VPC architecture in AWS with the following components:

- Custom VPC
- Public Subnets
- Private Subnets
- Database Subnets
- Internet Gateway
- NAT Gateways
- Route Tables
- Bastion Host EC2 Instance
- Security Groups

The design follows high availability principles by distributing resources across multiple Availability Zones.

---

## Project Structure

ResilientOps-Cloud-Architecture
│
├── modules
│   ├── vpc
│   └── ec2
│
├── bootstrap
│   └── backend configuration
│
├── .github
│   └── workflows
│       └── terraform.yml
│
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── dev.ci.tfvars
└── README.md

---

## Technologies Used

- Terraform
- AWS (VPC, EC2, NAT Gateway, Route Tables)
- Git
- GitHub
- GitHub Actions
- Infrastructure as Code (IaC)

---

## Terraform Concepts Demonstrated

This project demonstrates several important Terraform concepts:

### Modules
Infrastructure components are separated into reusable modules.

Example:

```
module "vpc"
module "ec2"
```

---

### Local Variables

Project tags are centrally defined using `locals`.

```
locals {
  project_tags = {
    contact     = "admin@nexuscloud360.com"
    owner       = "peter"
    application = "networking"
    project     = "terraform-enterprise-lab"
    environment = terraform.workspace
  }
}
```

---

### Tag Merging Strategy

Additional tags can be dynamically merged:

```
merged_tags = merge(local.project_tags, var.extra_tags)
```

This allows scalable tagging strategies used in enterprise infrastructure.

---

## CI Pipeline (GitHub Actions)

A GitHub Actions workflow automatically validates Terraform whenever code is pushed.

Pipeline steps include:

- Terraform format check
- Terraform validation
- Terraform plan

This ensures infrastructure changes are verified before deployment.

Example pipeline:

```
git push
     ↓
GitHub Actions
     ↓
terraform fmt
terraform validate
terraform plan
```

---

## Prerequisites

Before running this project ensure you have:

- AWS CLI configured
- Terraform installed
- Git installed
- AWS credentials configured

Example:

```
aws configure
```

---

## Deployment Instructions

Initialize Terraform:

```
terraform init
```

Format the Terraform code:

```
terraform fmt
```

Validate the configuration:

```
terraform validate
```

Preview the infrastructure changes:

```
terraform plan -var-file=dev.ci.tfvars
```

Deploy the infrastructure:

```
terraform apply -var-file=dev.ci.tfvars
```

---

## Destroy Infrastructure

To avoid AWS charges, destroy resources after testing:

```
terraform destroy -var-file=dev.ci.tfvars
```

---

## Verification Commands

Check running EC2 instances:

```
aws ec2 describe-instances --region us-east-1
```

Check NAT Gateways:

```
aws ec2 describe-nat-gateways --region us-east-1
```

Check VPCs:

```
aws ec2 describe-vpcs --region us-east-1
```

---

## DevOps Workflow

Typical development workflow:

Create a feature branch:

```
git checkout -b feature/vpc-module
```

Commit changes:

```
git add .
git commit -m "Add VPC module"
```

Push branch:

```
git push origin feature/vpc-module
```

Create a Pull Request and merge after review.

---

## Key DevOps Practices Demonstrated

- Infrastructure as Code
- Modular Terraform design
- Automated CI validation
- Git-based version control
- Safe branching workflow
- Environment tagging strategy

---

## Author

Peter Christian Agbenyega  
Cloud & DevOps Engineer

GitHub: https://github.com/Peter-Agbenyega

```

---

# Why this README is strong

This README shows recruiters:

✅ Terraform skills  
✅ AWS architecture  
✅ DevOps workflow  
✅ CI pipeline  
✅ infrastructure lifecycle  

This is exactly what **DevOps hiring managers expect** in GitHub projects.

---

If you want, I can also help you **upgrade this README to a recruiter-level portfolio README** that includes:

• architecture diagrams  
• Terraform workflow diagram  
• CI/CD pipeline diagram  
• AWS architecture visualization  

Those make your GitHub look **10x more professional**.
