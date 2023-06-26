data "tfe_organization" "org" {
  name = "${var.tf_org}"
}

resource "tfe_workspace" "aws" {
  name         = "${var.org_id}-${var.env}-aws-resources"
  organization = data.tfe_organization.org.name
  tag_names    = [lower(var.org_id), var.env]
  remote_state_consumer_ids = [tfe_workspace.k8s.id]
}

resource "tfe_workspace" "k8s" {
  name         = "${var.org_id}-${var.env}-k8s-resources"
  organization = data.tfe_organization.org.name
  tag_names    = [lower(var.org_id), var.env]
}

resource "tfe_variable_set" "varset" {
  name          = "${var.org_id}-${var.env}-varset"
  description   = "Variable set for ${var.org_id}."
  organization  = data.tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "aws" {
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.aws.id
}

resource "tfe_workspace_variable_set" "k8s" {
  variable_set_id = tfe_variable_set.varset.id
  workspace_id    = tfe_workspace.k8s.id
}