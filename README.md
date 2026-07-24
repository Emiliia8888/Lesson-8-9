# Django GitOps Platform

Production-style Django deployment platform built with Terraform, AWS EKS and GitOps principles.

## Project Overview

This project implements a complete cloud-native deployment workflow:

- Infrastructure as Code with Terraform
- Amazon EKS Kubernetes cluster
- Jenkins CI/CD pipeline
- ArgoCD GitOps deployment
- Amazon ECR container registry
- AWS Application Load Balancer
- PostgreSQL database
- AWS RDS PostgreSQL integration
- AWS Secrets Manager integration
- External Secrets Operator
- Kubernetes production hardening
- Horizontal Pod Autoscaling

---

# Architecture

The platform consists of the following components:

Developer
|
v
GitHub Repository
|
v
Jenkins CI/CD
|
v
Docker Build
|
v
Amazon ECR
|
v
ArgoCD
|
v
Amazon EKS
|
+----------------+
| |
v v
Django App PostgreSQL
| |
v v
AWS ALB AWS RDS


---

# Infrastructure

Infrastructure is provisioned using Terraform.

## AWS Region

eu-central-1

Name:
django-gitops-cluster


Implemented:

- VPC
- Public and private subnets
- NAT Gateway
- EKS Cluster
- Managed Node Group
- OIDC Provider
- IRSA
- EBS CSI Driver
- gp3 StorageClass

---

# Kubernetes Platform

## Installed Components

### Jenkins

Used for CI/CD automation.

Responsibilities:

- Build Docker images
- Push images to Amazon ECR
- Trigger deployment workflows


### ArgoCD

Used for GitOps deployment.

Application:

django-app


Status:
Synced
Healthy


Git repository:
https://github.com/Emiliia8888/Lesson-8-9.git


Branch:
main


---

# Application

## Django Application

Container image:
034255117140.dkr.ecr.eu-central-1.amazonaws.com/django-app-gitops


Deployment includes:

- Kubernetes Deployment
- Services
- Configurations
- Health checks
- Resource limits
- Security hardening

Application response:

Django app is running


---

# Production Hardening

Implemented Kubernetes production practices:

## Container Security

- Non-root containers
- SecurityContext
- Seccomp profile


## Availability

- Readiness probes
- Liveness probes
- PodDisruptionBudget


## Resource Management

Configured:

- CPU requests
- CPU limits
- Memory requests
- Memory limits


## Networking

Implemented:

- Kubernetes NetworkPolicy
- Private workload communication

---

# Database

## PostgreSQL

Kubernetes PostgreSQL workload:

- StatefulSet
- PersistentVolumeClaim
- StorageClass gp3


## Amazon RDS

Terraform module:
modules/rds/


Supports:

### Standard RDS

use_aurora=false

Creates:

- aws_db_instance
- aws_db_subnet_group
- aws_security_group
- aws_db_parameter_group


### Aurora
use_aurora=true


Creates:

- aws_rds_cluster
- aws_rds_cluster_instance

Current deployment:
Amazon RDS PostgreSQL


Endpoint:
django-rds-instance.ctskymysi6zv.eu-central-1.rds.amazonaws.com:5432


---

# Secrets Management

Implemented:

- AWS Secrets Manager
- IAM permissions
- External Secrets Operator
- ClusterSecretStore
- ExternalSecret

Status:
Ready


Secrets are synchronized automatically into Kubernetes.

---

# Networking

Implemented:

## AWS Load Balancer Controller

Provides:

- Kubernetes Ingress integration
- AWS ALB provisioning


## Application Load Balancer

Django application is publicly available through ALB.

Health check:
HTTP 200


---

# Autoscaling

Implemented:

## Metrics Server

Monitoring:

```bash
kubectl top pods

Horizontal Pod Autoscaler
Django application:
min replicas: 1
max replicas: 5
CPU target: 70%

Current CPU usage:
7%

Terraform Structure
.
├── modules
│   ├── vpc
│   ├── eks
│   ├── rds
│   ├── jenkins
│   └── argo_cd
│
├── charts
│   └── django-app
│
├── storage.tf
├── providers.tf
├── main.tf
└── variables.tf

Terraform Validation
Infrastructure deployment:
terraform validate

## Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform manages:
AWS infrastructure
Kubernetes resources
Helm releases

## Helm

```bash
helm dependency update charts/django-app
helm template charts/django-app
```

## Kubernetes

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

## Argo CD Verification

```bash
kubectl get application django-app -n argocd
```

Deployment Flow
Developer pushes code to GitHub
Jenkins builds Docker image
Image pushed to Amazon ECR
ArgoCD detects changes
Kubernetes deployment updated
Django application becomes available through ALB

Technologies
Terraform
AWS
Amazon EKS
Kubernetes
Helm
ArgoCD
Jenkins
Docker
Amazon ECR
Amazon RDS
PostgreSQL
AWS Secrets Manager
External Secrets Operator

Project Status
Production-style GitOps Django platform successfully deployed.
Implemented:
 Infrastructure automation
 Kubernetes orchestration
 CI/CD pipeline
 GitOps workflow
 Database integration
 Secret management
 Autoscaling
 Production security practices
