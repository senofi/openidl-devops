#data "awx_credential_type" "aws_user"{
#
#}
resource "awx_credential_type" "aws_credentials" {
  name = "openidl-aws-credentials"
  description = "AWS credentials configuration"
  injectors = jsonencode({
    "extra_vars" : {
      "aws_access_key" : "{{ aws_access_key }}",
      "aws_secret_key" : "{{ aws_secret_key }}",
      "aws_external_id" : "{{ aws_external_id }}",
      "aws_assume_role_arn" : "{{ aws_assume_role_arn }}"
    }
  })
  inputs = jsonencode({
    "fields" : [
      {
        "id" : "aws_access_key",
        "type" : "string",
        "label" : "aws_access_key",
        "secret" : true,
        "help_text" : "AWS IAM user access key for aws"
      },
      {
        "id" : "aws_secret_key",
        "type" : "string",
        "label" : "aws_secret_key",
        "secret" : true,
        "help_text" : "AWS IAM user secret key for aws"
      },
      {
        "id" : "aws_external_id",
        "type" : "string",
        "label" : "aws_external_id"
      },
      {
        "id" : "aws_assume_role_arn",
        "type" : "string",
        "label" : "aws_assume_role_arn"
      }
    ],
    "required" : [
      "aws.access_key",
      "aws.secret_key",
      "aws.external_id",
      "aws.assume_role_arn"
    ]
  })
}

resource "awx_credential_type" "openidl_config_git_repo" {
  name = "openidl-config-git-repo"
  description = "Private Git repository reference where the openIDL configuration is stored"
  injectors = jsonencode({
    "extra_vars": {
      "ssh_key": "{{ sshkey }}",
      "git_configs_repo_url": "{{ repourl }}",
      "git_configs_repo_branch": "{{ repobranch }}"
    }
  })
  inputs = jsonencode({
    "fields": [
      {
        "id": "sshkey",
        "type": "string",
        "label": "Base64 encoded string",
        "secret": true
      },
      {
        "id": "repourl",
        "type": "string",
        "label": "GIT repo URL"
      },
      {
        "id": "repobranch",
        "type": "string",
        "label": "Git repo branch"
      }
    ]
  })
}


resource "awx_credential_type" "openidl-app" {
  name = "openidl-app-config"
  description = "openIDL applications configuration"
  injectors = jsonencode({
    "extra_vars": {
      "aws_region": "‘{{ aws_region }}’",
      "aws_iam_role": "‘{{ aws_iam_role }}’",
      "gitrepo_name": "‘{{ gitrepo_name }}’",
      "aws_access_key": "‘{{ aws_access_key }}’",
      "aws_secret_key": "‘{{ aws_secret_key }}’",
      "gitrepo_branch": "‘{{ gitrepo_branch }}’",
      "aws_external_id": "‘{{ aws_external_id }}’",
      "app_cluster_name": "‘{{ app_cluster_name }}’",
      "gitrepo_password": "‘{{ gitrepo_pat }}’",
      "gitrepo_username": "‘{{ gitrepo_username }}’",
      "vault_secret_name": "‘{{ vault_secret_name }}’"
    }
  })
  inputs = jsonencode({
    "fields": [
      {
        "id": "aws_access_key",
        "type": "string",
        "label": "AWS access key",
        "secret": true,
        "help_text": "AWS IAM user access key"
      },
      {
        "id": "aws_secret_key",
        "type": "string",
        "label": "AWS secret key",
        "secret": true,
        "help_text": "AWS IAM user secret key"
      },
      {
        "id": "aws_iam_role",
        "type": "string",
        "label": "AWS IAM role",
        "help_text": "AWS IAM role to be assumed"
      },
      {
        "id": "aws_external_id",
        "type": "string",
        "label": "AWS external id",
        "help_text": "Externl ID set during IAM user/role configuration"
      },
      {
        "id": "aws_region",
        "type": "string",
        "label": "AWS region",
        "help_text": "AWS Region"
      },
      {
        "id": "gitrepo_name",
        "type": "string",
        "label": "‘Git Repository (without https://)’",
        "help_text": "Git repository URL"
      },
      {
        "id": "gitrepo_branch",
        "type": "string",
        "label": "Git branch name",
        "help_text": "Git repository branch name"
      },
      {
        "id": "gitrepo_username",
        "type": "string",
        "label": "Gitrepo username",
        "help_text": "Git repository login username"
      },
      {
        "id": "gitrepo_pat",
        "type": "string",
        "label": "Gitrepo PAT",
        "secret": true,
        "help_text": "Git repository personl access token"
      },
      {
        "id": "app_cluster_name",
        "type": "string",
        "label": "Application cluster name",
        "help_text": "OpenIDL Application EKS cluster name"
      },
      {
        "id": "vault_secret_name",
        "type": "string",
        "label": "vault secret name",
        "help_text": "Vault secret name provisioned in AWS secrets manager"
      }
    ],
    "required": [
      "aws_access_key",
      "aws_secret_key",
      "aws_iam_role",
      "aws_external_id",
      "aws_region",
      "gitrepo_username",
      "gitrepo_password",
      "gitrepo_name",
      "gitrepo_branch",
      "app_cluster_name",
      "vault_secret_name"
    ]
  })
}