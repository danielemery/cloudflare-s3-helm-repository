locals {
  full_domain = var.subdomain == null ? var.domain : "${var.subdomain}.${var.domain}"
}

// Cloudflare record, & rule
data "cloudflare_zone" "helm_destination_zone" {
  name = var.domain
}

resource "cloudflare_record" "helm_record" {
  zone_id = data.cloudflare_zone.helm_destination_zone.id
  name    = var.subdomain == null ? "@" : var.subdomain
  value   = aws_s3_bucket_website_configuration.helm_bucket_configuration.website_endpoint
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_page_rule" "helm_flexible_ssl" {
  zone_id  = data.cloudflare_zone.helm_destination_zone.id
  target   = "${local.full_domain}/*"
  priority = var.cloudflare_page_rule_priority

  actions {
    ssl = "flexible"
  }
}

// AWS bucket and configuration
resource "aws_s3_bucket" "helm_bucket" {
  bucket = local.full_domain
}

data "cloudflare_ip_ranges" "cloudflare" {}
resource "aws_s3_bucket_policy" "cloudflare_proxy_access" {
  bucket = aws_s3_bucket.helm_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.helm_bucket.arn}/*",
        "Condition" : {
          "IpAddress" : {
            "aws:SourceIp" : concat(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks, data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks)
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "helm_bucket_configuration" {
  bucket = aws_s3_bucket.helm_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

// Bucket index file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.helm_bucket.bucket
  key          = "index.html"
  content      = <<EOT
  <html>
    <head>
      <title>Helm Repository</title>
    </head>
    <body>
      <p>If you are seeing this you have probably made it here in error!</p>
      <p>This is the home of a repository of helm charts intended to be interacted with using the <a href="https://helm.sh/docs/">Helm CLI</a>.</p>
    </body>
  </html>
  EOT
  content_type = "text/html"
}

// IAM Policy and user to deploy to bucket
resource "aws_iam_policy" "deploy_policy" {
  name        = var.aws_iam_policy_name
  description = "Role to allow publishing of helm charts to the ${local.full_domain} bucket."
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListObjectsInBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "${aws_s3_bucket.helm_bucket.arn}"
        ]
      },
      {
        "Sid" : "AllObjectActions",
        "Effect" : "Allow",
        "Action" : "s3:*Object",
        "Resource" : [
          "${aws_s3_bucket.helm_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "deploy_user" {
  name = var.aws_iam_user_name
}

resource "aws_iam_user_policy_attachment" "deploy_user_policy" {
  user       = aws_iam_user.deploy_user.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}

resource "aws_iam_access_key" "deploy_user_key" {
  user = aws_iam_user.deploy_user.name
}
