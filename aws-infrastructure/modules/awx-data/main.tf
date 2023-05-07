terraform {
  required_providers {
    awx = {
      source = "denouche/awx"
      version = "0.19.0"
    }
  }
}

provider "awx" {
  hostname = var.awx_hostname
  username = var.aws_username
  password = var.awx_password
}

provider "aws" {}