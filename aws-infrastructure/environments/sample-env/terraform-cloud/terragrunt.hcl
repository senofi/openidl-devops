include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/terraform-cloud"
}

inputs = {

  tags = {
    Network = "openIDL"
    Environment = "test"
  }
}


