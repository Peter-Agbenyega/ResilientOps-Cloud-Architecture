# ResilientOps AWS Reference Architecture: Architecture Overview

## Purpose

This document explains the architectural intent behind the Terraform configuration and complements the root README with slightly more design context.

## What The Repository Demonstrates

The current implementation demonstrates:

- a custom VPC spanning two Availability Zones
- public, private, and database-ready subnet tiers
- an Internet Gateway and per-AZ NAT Gateway pattern
- a bastion host for controlled SSH administration
- private EC2 hosts for segmented internal access patterns
- an Application Load Balancer for centralized ingress
- an autoscaling application tier for elastic compute delivery
- remote Terraform state with DynamoDB locking for safer operations

## Core Layout

```text
Internet
   |
   v
Application Load Balancer
   |
   v
Auto Scaling Group

Admin User
   |
   v
Bastion Host
   |
   v
Private EC2 Hosts
```

## Public, Private, and Database-Ready Subnets

### Public Subnets

Public subnets host the resources that need internet-facing behavior, including the bastion host, Application Load Balancer, and NAT Gateways.

### Private Subnets

Private subnets host internal EC2 instances that should not require direct public exposure.

### Database-Ready Subnets

The repository includes dedicated database-ready subnet space even though a database module is not currently active in the root deployment. This strengthens the reference architecture story by showing forward planning for a more complete multi-tier design.

## Design Choices

- A bastion pattern is used because it is a recognizable controlled-access pattern for infrastructure reviewers.
- An ALB is used to centralize ingress rather than exposing individual application instances directly.
- Autoscaling is used to demonstrate grouped compute management instead of hand-managed instance fleets.
- Per-AZ NAT Gateways favor resilience and cleaner network boundaries over a cheaper single-NAT design.

## Honest Boundary

The autoscaling application tier currently uses public subnets. That is acceptable for a working reference architecture, but it should be described as a staged architecture with a clear path toward a more private application tier rather than as a fully hardened end state today.
