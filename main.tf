terraform {

  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.4"
    }

    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "random" {}
provider "aws" {}

resource "random_pet" "namespace" {}

resource "random_password" "secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "secret" {
  name        = "/session_secret/v2/${random_pet.namespace.id}"
  description = "Session secret value"
  type        = "SecureString"
  value       = random_password.secret.result
}

data "aws_region" "current" {}

output "sessionSecret" {
  value = aws_ssm_parameter.secret.arn
}

output "SESSION_SECRET" {
  value = aws_ssm_parameter.secret.arn
}


