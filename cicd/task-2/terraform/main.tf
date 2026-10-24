
terraform {
  required_version = ">= 1.6.0"
}

resource "terraform_data" "hello" {
  input = "Hello from Terraform CI"
}
