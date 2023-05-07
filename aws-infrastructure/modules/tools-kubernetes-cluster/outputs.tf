output cluster_endpoint {
  value = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}

output "self_managed_node_groups" {
  value = module.eks.self_managed_node_groups
}

output "aws_auth_configmap_yaml" {
  value = module.eks.aws_auth_configmap_yaml
}

output "rds_hostname" {
  description = "OpsTools DB instance hostname"
  value       = aws_db_instance.ops_tools_db.address
}

output "rds_port" {
  description = "OpsTools DB instance port"
  value       = aws_db_instance.ops_tools_db.port
}

output "rds_username" {
  description = "OpsTools DB instance root username"
  value       = aws_db_instance.ops_tools_db.username
}
