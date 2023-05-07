include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/iam-roles-users"
}

inputs = {

  tags = {
    Network = "openIDL"
    Environment = "test"
  }
}


