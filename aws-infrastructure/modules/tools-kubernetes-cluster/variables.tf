
variable "aws_external_id" {
}

variable "aws_role_arn" {
}

variable "aws_secret_key" {
}

variable "aws_access_key" {
}

variable "cluster_name" {
  default = "ops-k8s"
}

variable "region" {
  default = "us-east-2"
}

# variable "public_domain" {
# }

variable "domain_comment" {
  default = "Custom domain"
}

variable "ops_tools_db_password" {
  type = string
}

variable "org_id" {
  type = string
}

variable "env" {
  type = string
  default = "test"
}
