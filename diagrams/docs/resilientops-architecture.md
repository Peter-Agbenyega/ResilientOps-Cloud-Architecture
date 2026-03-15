# ResilientOps Architecture Diagram

```mermaid
flowchart TD

Internet[Internet Users]

IGW[Internet Gateway]

ALB[Application Load Balancer]

ASG[Auto Scaling Group]

EC2[Private EC2 Instances]

DB[Database Subnet Layer]

Internet --> IGW
IGW --> ALB
ALB --> ASG
ASG --> EC2
EC2 --> DB

Explanation

This diagram represents the simplified architecture flow of the ResilientOps AWS Infrastructure.

Traffic flows through the following path:
	1.	Internet users access the system.
	2.	Traffic enters the AWS environment through the Internet Gateway.
	3.	The Application Load Balancer distributes requests.
	4.	Auto Scaling manages compute capacity.
	5.	Private EC2 instances handle application workloads.
	6.	Backend data services operate in isolated database subnets.

The design separates public access, application workloads, and database layers to improve security and resilience.  

