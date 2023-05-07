#resource "aws_iam_role" "k8s_admin" {
#  name        = "k8s_admin"
#  description = "IAM role used to access Kubernetes clusters"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "sts:AssumeRole",
#          "sts:TagSession"
#        ]
#        Effect = "Allow"
#        Sid    = ""
#        Principal = {
#          AWS = aws_iam_user.tf_user.arn
#        }
#        Condition = {
#          "StringEquals" = {
#            "sts:ExternalId" = "terraform"
#          }
#        }
#      }
#    ]
#  })
#
#  tags = {
#    Used_by     = "terraform",
#    Application = "openidl"
#  }
#}
