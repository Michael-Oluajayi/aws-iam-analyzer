terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# IAM Access Analyzer — detects overly permissive policies
resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "iam-access-analyzer"
  type          = "ACCOUNT"

  tags = {
    Name = "iam-access-analyzer"
  }
}

# SNS topic for Access Analyzer alerts
resource "aws_sns_topic" "analyzer_alerts" {
  name = "iam-analyzer-alerts"

  tags = {
    Name = "iam-analyzer-alerts"
  }
}

# Email subscription for alerts
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.analyzer_alerts.arn
  protocol  = "email"
  endpoint  = "oluajayimichael25@gmail.com"
}

# CloudWatch alarm for Access Analyzer findings
resource "aws_cloudwatch_metric_alarm" "analyzer_findings" {
  alarm_name          = "iam-analyzer-findings"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FindingsCount"
  namespace           = "AWS/AccessAnalyzer"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alert when IAM Access Analyzer detects overly permissive policies"
  alarm_actions       = [aws_sns_topic.analyzer_alerts.arn]

  tags = {
    Name = "iam-analyzer-findings-alarm"
  }
}

# S3 bucket to store analyzer findings
resource "aws_s3_bucket" "findings" {
  bucket        = "iam-analyzer-findings-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "iam-analyzer-findings"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Block all public access to findings bucket
resource "aws_s3_bucket_public_access_block" "findings" {
  bucket                  = aws_s3_bucket.findings.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch log group for analyzer findings
resource "aws_cloudwatch_log_group" "analyzer" {
  name              = "/iam/access-analyzer"
  retention_in_days = 90

  tags = {
    Name = "iam-access-analyzer-logs"
  }
}