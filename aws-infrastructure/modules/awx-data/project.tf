resource "awx_organization" "default" {
  name = "${var.org_name}-org"
}

resource "awx_project" "default" {
  name                 = "${var.org_name}-project"
  scm_type             = "git"
  scm_url              = var.git_url
  scm_branch           = var.git_branch
  scm_update_on_launch = true
  organization_id      = awx_organization.default.id
}

resource "awx_team" "default" {

}

resource "awx_host" "bastion" {
  name         = var.bastion_host
  description  = "Bastion host for ${var.org_name}"
  inventory_id = awx_inventory.default.id
  enabled      = true
#  variables = <<YAML
#---
#ansible_host: ${var.bastion_host}
#YAML
}

resource "awx_inventory" "default" {
  name            = "${var.org_name}-inventory"
  organization_id = awx_organization.default.id
}