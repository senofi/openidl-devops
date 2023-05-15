include "root" {
  path = find_in_parent_folders()
}

locals {
  # Load variables
  common = yamldecode(file(find_in_parent_folders("org-vars.yaml")))
}

terraform {
  source = "../../..//modules/tools-kubernetes-cluster"
}

inputs = {
  aws_access_key  = local.common.terraform.aws_access_key
  aws_secret_key  = local.common.terraform.aws_secret_key
  aws_external_id = local.common.terraform.aws_external_id
  aws_role_arn    = local.common.terraform.aws_role_arn
}
