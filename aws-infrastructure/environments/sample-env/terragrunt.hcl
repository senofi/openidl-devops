locals {
  workspace_name = "testnet-openidl-ops"

}

inputs = {
  ops_tools_db_password = "9%$oK3#NpNfIW#$"

  tags = {
    Network = "openIDL"
    Environment = "test"
  }
}

generate "versions" {
  path = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
    tfe = {
      version = "~> 0.37.0"
    }
  }
}
EOF
}

#generate "remote_state" {
#  path      = "backend.tf"
#  if_exists = "overwrite_terragrunt"
#  contents = <<EOF
#terraform {
#  cloud {
#    organization = "openIDL"
#    workspaces {
#      name = "${local.workspace_name}"
#    }
#  }
#}
#EOF
#}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars.json"
  if_exists = "overwrite"
  disable_signature = true
  contents = jsonencode(yamldecode(file(find_in_parent_folders("org-vars.yaml"))))
}