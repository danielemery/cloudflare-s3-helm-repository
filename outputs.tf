output "deploy_user_iam_key" {
  value       = aws_iam_access_key.deploy_user_key
  description = "AWS iam key for a user with deploy access to the created helm repository bucket"
  sensitive   = true
}
