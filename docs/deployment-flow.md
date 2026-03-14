# ResilientOps AWS Reference Architecture: Deployment Flow

## Purpose

This document explains how the repository is intended to be operated as a repeatable Terraform project both locally and through CI.

## Backend Bootstrap

The `bootstrap/` directory exists to provision the remote state bucket and DynamoDB lock table used by the root Terraform configuration.

That separation matters because Terraform cannot create the backend it is already configured to depend on during the same run.

## Local Workflow

```bash
terraform init -input=false
terraform workspace select dev || terraform workspace new dev
terraform fmt -recursive
terraform validate
terraform plan -input=false -var-file=dev.tfvars
terraform apply -input=false -var-file=dev.tfvars
```

## CI Workflow Intent

The repository’s GitHub Actions workflow models a review-first infrastructure workflow:

- pull requests run formatting, validation, and plan
- pushes to `main` can run apply

This helps make infrastructure changes reviewable before they are executed.

## Operational Notes

- `dev.tfvars` should remain local and untracked.
- CI-based plan or apply should inject environment-specific values securely rather than rely on committed variable files.
- Backend resources, AWS credentials, and the selected workspace must align or Terraform operations will fail for environmental reasons rather than configuration reasons.
