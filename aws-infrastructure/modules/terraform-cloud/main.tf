data "tfe_organization" "openidl" {
  name = "${var.tfc_organization}"
}

resource "tfe_workspace" "aws" {
  name         = "${var.project}-${var.org_name}-aws-resources"
  organization = data.tfe_organization.openidl.name
  tag_names    = [var.project, var.org_name]
  remote_state_consumer_ids = [tfe_workspace.k8s.id]
}

resource "tfe_workspace" "k8s" {
  name         = "${var.project}-${var.org_name}-k8s-resources"
  organization = data.tfe_organization.openidl.name
  tag_names    = [var.project, var.org_name]
}

resource "tfe_variable_set" "varset" {
  name          = "${var.project}-${var.org_name}-varset"
  description   = "Variable set for ${var.org_name}."
  organization  = data.tfe_organization.openidl.name
  workspace_ids = [tfe_workspace.aws.id, tfe_workspace.k8s.id]
}
