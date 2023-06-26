include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/terraform-cloud"
}


generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "local" {}
}
EOF
}

inputs = {

  tags = {
    Network = "openIDL"
    Environment = "test"
  }
}


