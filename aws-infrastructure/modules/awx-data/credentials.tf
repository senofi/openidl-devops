resource "awx_credential" "aws-user" {
  name = "${var.org_name}-aws-credentials"
  description = "AWS user credentials"
  organization_id = awx_organization.default.id
  credential_type_id = awx_credential_type.aws_credentials.id
  inputs = jsonencode({
    "aws.access_key": var.aws_access_key,
    "aws.secret_key": var.aws_secret_key,
    "aws.external_id": var.aws_external_id,
    "aws.assume_role_arn": var.aws_assume_role_arn
  })
}

resource "awx_credential" "github_ssh_key_and_url" {
  name = "${var.org_name}-Git-Config"
  description = "Git configuration"
  organization_id = awx_organization.default.id
  credential_type_id = awx_credential_type.openidl_config_git_repo.id
  inputs = jsonencode({
    "aws.sshkey": var.openidl_config_git_ssh_key,
    "aws.repourl": var.openidl_config_git_repo_url,
    "aws.repokey": var.openidl_config_git_repo_branch
  })
}

resource "awx_credential" "openidl-app" {
  name = "${var.org_name}-app-config"
  description = "openIDL Applications config"
  organization_id = awx_organization.default.id
  credential_type_id = awx_credential_type.openidl-app.id
  inputs = jsonencode({
    "aws.access_key": var.aws_access_key,
    "aws.secret_key": var.aws_secret_key,
    "aws.external_id": var.aws_external_id,
    "aws.assume_role_arn": var.aws_assume_role_arn
  })
}

resource "awx_credential_machine" "bastion" {
  organization_id = awx_organization.default.id
  name = "${var.org_name}-bastion"
  username = var.bastion_username
  ssh_key_data = var.bastion_ssh_key

}