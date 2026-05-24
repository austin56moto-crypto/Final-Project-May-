variable "aws_region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Name prefix for all resources."
  default     = "interntask-ai-cloud"
}

variable "cognito_domain_prefix" {
  type        = string
  description = "Cognito hosted UI domain prefix."
  default     = "interntask-ai-cloud"
}

