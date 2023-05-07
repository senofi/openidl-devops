variable "org_name" {
  type = string
  description = "Organization name"
}

variable "git_url" {
  type = string
  description = "The GIT repository URL"
}

variable "git_branch" {
  type = string
  description = "The GIT repository branch to use"
}

variable "aws_assume_role_arn" {
}
variable "aws_external_id" {
}
variable "aws_secret_key" {
}
variable "aws_access_key" {
}


variable "openidl_config_git_ssh_key" {
}
variable "openidl_config_git_repo_url" {
}
variable "openidl_config_git_repo_branch" {
}


variable "awx_hostname" {
  default = "http://localhost"
}
variable "aws_username" {
  default = "admin"
}
variable "awx_password" {
  default = "356Kj79dJp2VKu7"
}

variable "bastion_host" {
  default = ""
}
