# AWS IAM Access Analyzer

## Overview
This project deploys AWS IAM Access Analyzer using Terraform to automatically detect overly permissive IAM policies and resource configurations. It continuously monitors your AWS account and alerts you when any resource is accessible from outside your account.

## Architecture
- **IAM Access Analyzer** — Continuously scans for overly permissive policies
- **SNS Topic** — Sends email alerts when findings are detected
- **CloudWatch Alarm** — Triggers on any new Access Analyzer findings
- **S3 Bucket** — Stores all findings securely, public access blocked
- **CloudWatch Log Group** — 90 day retention for finding history

## Security Features
- Continuous monitoring for policy misconfigurations
- Real time alerting on any new findings
- Findings stored securely with public access blocked
- 90 day log retention for compliance and auditing
- Detects unintended public access to S3, IAM roles, KMS keys, and more

## Tools Used
- Terraform v1.15.5
- AWS CLI
- AWS Services: IAM Access Analyzer, SNS, CloudWatch, S3

## How to Deploy
1. Clone this repository
2. Configure AWS credentials: `aws configure`
3. Update your email in `main.tf` for SNS alerts
4. Initialize Terraform: `terraform init`
5. Preview changes: `terraform plan`
6. Deploy: `terraform apply`
7. Confirm your SNS email subscription

## What I Learned
This project taught me how to use AWS IAM Access Analyzer to proactively detect security misconfigurations before they become breaches. I learned how to automate policy analysis, route findings to alerting systems, and store evidence securely — skills directly used by IT Security Analysts and Cloud Security Engineers.

## Author
Michael Olu-Ajayi — Aspiring Cloud Security Engineer