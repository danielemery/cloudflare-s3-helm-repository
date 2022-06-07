variable "aws_access_key_id" {
  type        = string
  description = "Admin AWS access key id"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "Admin AWS secret access key"
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "Admin cloudflare api token"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region in which to create the bucket"
}
