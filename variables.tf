variable "domain" {
  type        = string
  description = "The name of the domain and cloudflare zone (eg `mysite.com`)"
}

variable "subdomain" {
  type        = string
  description = "Optional subdomain at which the helm repo will be served (eg `helm` would result in `helm.mysite.com`)"
  default     = null
  nullable    = true
}

variable "aws_iam_policy_name" {
  type        = string
  description = "name for an iam policy that allows the publishing of charts"
}

variable "aws_iam_user_name" {
  type        = string
  description = "name for an iam user to use for publishing charts"
}

variable "cloudflare_page_rule_priority" {
  type        = number
  description = "Cloudflare page rule priority, you only need this if you have multiple projects/modules rules in the same zone and it's resulting in clashes."
  default     = 1
  nullable    = true
}
