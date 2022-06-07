# cloudflare-s3-helm-repository

Terraform module and documentation for using a cloudflare-proxied s3 bucket as a helm repository.

- Creates the s3 bucket and configures with a whitelist policy only allowing cloudflare CIDR range to read
- Creates a cloudflare dns rule pointing to the bucket a long with a page rule allowing flexible ssl for this route
- Creates an iam policy & user with deploy access to the bucket (for use in chart CI/CD pipelines)

See `./examples/standard` for example usage.
