
locals {
  # Load variables
  common = yamldecode(file(find_in_parent_folders("org-vars.yaml")))
  local = yamldecode(file("${get_terragrunt_dir()}/local-vars.yaml"))
}

inputs = {

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
      version = "~> 0.45.0"
    }
  }
}
EOF
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  cloud {
    organization = "${local.common.tf_org}"
    workspaces {
      name = "${local.common.org_id}-${local.common.env}-${local.local.module}"
    }
  }
}
EOF
}

generate "tfvars" {
  path      = "terragrunt.auto.tfvars.json"
  if_exists = "overwrite"
  disable_signature = true
  contents = jsonencode(yamldecode(file(find_in_parent_folders("org-vars.yaml"))))
}