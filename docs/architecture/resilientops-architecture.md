# ResilientOps AWS Architecture

## Overview

ResilientOps Cloud Architecture is a modular Terraform-based AWS infrastructure project designed to demonstrate secure, scalable, and resilient cloud application delivery.

The architecture models a layered AWS environment with public entry points, private compute resources, and isolated database subnets.

## Architecture Flow

```text
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Application Load Balancer
   │
   ▼
Auto Scaling Group
   │
   ▼
Private EC2 Instances
   │
   ▼
Database Subnets
   │
   ▼
RDS / Database Layer

Main Components
	•	Custom VPC
	•	Public Subnets
	•	Private Subnets
	•	Database Subnets
	•	Internet Gateway
	•	NAT Gateways
	•	Route Tables
	•	Application Load Balancer
	•	Auto Scaling Group
	•	Private EC2 Instances
	•	Bastion Host
	•	Security Groups

Design Goal

The architecture is designed to demonstrate how Terraform can be used to provision infrastructure that supports security, availability, and repeatable deployment practices in AWS.

Why This Matters

This project helps show how modular infrastructure design can improve maintainability, reduce manual configuration risks, and support resilient cloud application environments.