# Standard Example

Standard example module usage creating a helm repository at [helm.invariablyabandoned.com](https://invariablyabandoned.com).

## Usage

1. Populate a `secrets.tfvars` file with the values described in `./variables.tf`
2. Create helm repository with
    ```sh
    terraform apply -var-file="secrets.tfvars"
    ```
