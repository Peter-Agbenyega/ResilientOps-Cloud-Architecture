# ResilientOps AWS Reference Architecture: Security Considerations

## Security Approach

This repository is not presented as a certified security baseline, but it does demonstrate several AWS security patterns that are relevant to secure application delivery.

## Security Patterns Demonstrated

### Network Segmentation

Public, private, and database-ready subnet tiers reduce flat-network exposure and make trust boundaries clearer.

### Controlled Administrative Access

The bastion host pattern narrows the intended SSH entry path for internal hosts instead of opening every host directly to the internet.

### Security Group Boundaries

Security groups are used to distinguish edge traffic, application-tier traffic, and internal host access.

### Private Internal Hosts

The private EC2 instances are placed in private subnets and do not receive public IP addresses.

### Remote State Safety

Terraform state is designed to live in S3 with DynamoDB locking, which reduces operational mistakes caused by concurrent changes or fragmented local state.

## Current Security Caveats

- The autoscaling application tier currently runs in public subnets.
- The application server security group is broader than an ideal ALB-only ingress model.
- HTTPS is not enabled in the current implementation.
- The repository should be described as security-conscious and portfolio-grade, not as fully production-hardened.

## Sensible Next Hardening Steps

- Move the autoscaling application tier into private subnets behind the ALB.
- Restrict application instance ingress to the ALB security group and approved administrative paths only.
- Replace or reduce SSH dependency with more tightly controlled access methods such as AWS Systems Manager where appropriate.
- Externalize CI and environment-specific secrets so sensitive values are never committed to the repository.
