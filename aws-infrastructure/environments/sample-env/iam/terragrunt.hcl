include "root" {
  path = find_in_parent_folders()
}

locals {
  # Load variables
  common = yamldecode(file(find_in_parent_folders("org-vars.yaml")))
}

terraform {
  source = "../../..//modules/iam-roles-users"
}

inputs = {
  aws_access_key = local.common.iam.aws_access_key
  aws_secret_key = local.common.iam.aws_secret_key
  
  tags = {
    Network = "openIDL"
    Environment = "test"
  }
}


