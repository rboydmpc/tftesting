terraform {
   required_version = ">= 0.12.31"

#   required_providers {
#     aws = ">= 4.0.0"
#   }
}

provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
  }

variable "access_key" {}
variable "secret_key" {}
variable "region" {
   default = "us-east-1"
}

variable "bucket_prefix" {
   description = "Enter mutiliple bucket prefix names to cretae multiple buckets like ''test'' or ''test'', ''new''"
}

variable "acl_value" {
   default = "private"
}

variable "bucket_count" {
}

variable "force_destroy" {
    type = bool   
    default = "false"
}

variable "mytest" {
}
resource "aws_s3_bucket" "s3" {
    count = var.bucket_count
    bucket_prefix = var.bucket_prefix
    force_destroy = var.force_destroy
    tags = {
    Date = timestamp()
    mytest = var.mytest
    }
}
output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.s3[0].arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.s3[0].id
}

output "domainname" {
  description = "Domain NAme of Bucket"
  value       = aws_s3_bucket.s3[0].bucket_domain_name
}
