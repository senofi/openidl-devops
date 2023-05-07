# Kubernetes module definitions

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.cluster_name}_EBS_CSI_DriverRole"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.tags
}

data "aws_caller_identity" "current" {}
data "aws_iam_session_context" "current" {
  # "This data source provides information on the IAM source role of an STS assumed role. For non-role ARNs, this data source simply passes the ARN through in issuer_arn."
  arn = data.aws_caller_identity.current.arn
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name                    = var.cluster_name
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Encryption key
  create_kms_key            = true
  kms_key_administrators = [data.aws_iam_session_context.current.issuer_arn]

  cluster_encryption_config = [
    {
      resources = ["secrets"]
    }
  ]
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_ntp_ipv4_cidr_block = ["169.254.169.123/32"]
  node_security_group_additional_rules    = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    # Default node group - as provided by AWS EKS
    default_node_group = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      disk_size = 50

      # Remote access cannot be specified with a launch template
      #      remote_access = {
      #        ec2_ssh_key               = aws_key_pair.this.key_name
      #        source_security_group_ids = [aws_security_group.remote_access.id]
      #      }
    }
  }

  #  cluster_identity_providers = {
  #    sts = {
  #      client_id = "sts.amazonaws.com"
  #    }
  #  }

  manage_aws_auth_configmap = false

  #  aws_auth_node_iam_role_arns_non_windows = [
  #    module.self_managed_node_group.iam_role_arn,
  #  ]

  #  aws_auth_roles = [
  #    {
  #      rolearn  = var.k8s_admin_role_arn
  #      username = "role1"
  #      groups   = ["system:masters"]
  #    },
  #  ]

  #  aws_auth_users = [
  #    {
  #      userarn  = "arn:aws:iam::66666666666:user/user1"
  #      username = "user1"
  #      groups   = ["system:masters"]
  #    },
  #    {
  #      userarn  = "arn:aws:iam::66666666666:user/user2"
  #      username = "user2"
  #      groups   = ["system:masters"]
  #    },
  #  ]

  #  aws_auth_accounts = [
  #    "777777777777",
  #    "888888888888",
  #  ]

  tags = local.tags
}

#module "self_managed_node_group" {
#  source = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"
#
#}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.cluster_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  intra_subnets   = ["10.0.7.0/28", "10.0.7.16/28", "10.0.7.32/28"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}

resource "aws_security_group" "additional" {
  name_prefix = "${var.cluster_name}-additional"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = local.tags
}
