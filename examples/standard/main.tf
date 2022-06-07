module "standard_helm_repo" {
  source = "../../"
  domain = "invariablyabandoned.com"
  subdomain = "helm"
  aws_iam_policy_name = "invariablyabandoned-helm-deploy"
  aws_iam_user_name = "invariablyabandoned-helm-deploy"
}
