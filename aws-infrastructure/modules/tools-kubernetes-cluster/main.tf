locals {

  tags = {
    Network     = var.org_id
    Project     = "openIDL"
    Environment = var.env
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

provider "aws" {
  # The security credentials for AWS Account A.
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region

  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn    = var.aws_role_arn
    # (Optional) The external ID created in step 1c.
    external_id = var.aws_external_id
  }
}

#provider "helm" {
#  kubernetes {
#    host                   = data.aws_eks_cluster.
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_eks_cluster.certificate_authority.0.data)
#    token                  = data.aws_eks_cluster_auth.app_eks_cluster_auth.token
#    exec {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      args        = ["eks", "get-token", "--cluster-name", local.name]
#      command     = "aws"
#    }
#  }
#}
