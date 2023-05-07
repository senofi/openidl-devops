
#output "k8s_admin_arn" {
#  value = aws_iam_role.k8s_admin.arn
#}

output "access_key" {
  value     = aws_iam_access_key.tf_user_access_key.id
  sensitive = true
}

output "secret_key" {
  value     = aws_iam_access_key.tf_user_access_key.secret
  sensitive = true
}