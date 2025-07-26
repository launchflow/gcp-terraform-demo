
# Infra.new Demo Environment

This repository contains a sample GCP Terraform environment designed to showcase **infra.new's** automated capabilities for detecting and fixing infrastructure drift and policy violations.

## Overview

This is a realistic development environment that includes common GCP services:
- Cloud Run application service
- Cloud SQL PostgreSQL database  
- Cloud Storage bucket for assets
- Compute Engine instance for additional workloads
- Service accounts and IAM configurations
- Networking and firewall rules

## Purpose

This environment serves as a demonstration platform for infra.new's ability to:

1. **Automatically detect policy violations** - Identify security and compliance issues in your infrastructure
2. **Fix policy violations** - Automatically remediate detected policy issues
3. **Detect infrastructure drift** - Identify when actual infrastructure differs from Terraform state
4. **Fix infrastructure drift** - Automatically bring infrastructure back in sync with Terraform configuration

## Project Structure

```
infra/
└── environments/
    └── dev/
        ├── main.tf      # Main Terraform configuration
        └── outputs.tf   # Output definitions
```

## Getting Started

### Prerequisites

- GCP Project with appropriate APIs enabled
- Terraform installed
- gcloud CLI configured

### Deploy the Environment

```bash
cd infra/environments/dev
terraform init
terraform plan
terraform apply
```

### Resources Created

The environment provisions:

- **Cloud Run Service** (`demo-application`) - Containerized web application
- **Cloud SQL Instance** - PostgreSQL database for application data
- **Storage Bucket** - Asset storage with versioning enabled
- **Compute Instance** (`demo-app-server`) - VM for additional processing
- **Service Account** - Identity for application workloads
- **Firewall Rules** - Network access controls

## Testing Infra.new Capabilities

Once deployed, this environment can be used to demonstrate:

### Policy Violation Detection & Remediation
Infra.new will scan the infrastructure and identify potential security and compliance issues, then provide automated fixes.

### Drift Detection & Remediation  
Manual changes made to resources outside of Terraform will be detected as drift, and infra.new can automatically generate plans to restore the desired state.

## Outputs

The environment provides several useful outputs:
- Application URLs and endpoints
- Database connection information
- Service account details
- Instance IP addresses

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## About Infra.new

This demo environment showcases infra.new's intelligent infrastructure management capabilities. Visit [infra.new](https://infra.new) to learn more about automated infrastructure governance and drift management.
