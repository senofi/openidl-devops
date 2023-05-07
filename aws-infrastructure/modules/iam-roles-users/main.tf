data "aws_iam_policy_document" "tf_admin_policy_document" {
  statement {
    actions = [
      "iam:*",
      "ec2:*",
      "s3:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "logs:*",
      "ses:*",
      "cognito-idp:*",
      "eks:*",
      "kms:*",
      "dynamodb:*",
      "acm:*",
      "autoscaling:*",
      "elasticloadbalancing:*",
      "ebs:*",
      "route53:*",
      "route53domains:*",
      "sts:*",
      "secretsmanager:*",
      "cloudformation:ListStacks",
      "sns:*",
      "application-autoscaling:*",
      "lambda:*",
      "cloudfront:*",
      "apigateway:*",
      "rds:*"
    ]

    resources = ["*"]

  }
}

resource "aws_iam_policy" "tf_admin_policy" {
  name        = "tf_admin_policy"
  path        = "/"
  description = "Terraform admin policy"

  policy = data.aws_iam_policy_document.tf_admin_policy_document.json
  tags   = {
    Used_by     = "terraform",
    Application = "openidl"
  }
}

resource "aws_iam_role" "tf_automation" {
  name        = "tf_automation"
  description = "IAM role used with Terraform for AWS resources provisioning"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_user.terraform_user.arn
        }
        Condition = {
          "StringEquals" = {
            "sts:ExternalId" = "terraform"
          }
        }
      }
    ]
  })

  tags = {
    Used_by     = "terraform",
    Application = "openidl"
  }
}


resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
  role       = aws_iam_role.tf_automation.name
  policy_arn = aws_iam_policy.tf_admin_policy.arn
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
  path = "/"

  tags = {
    Used_by     = "terraform",
    Application = "openidl"
  }
}

resource "aws_iam_access_key" "tf_user_access_key" {
  user = aws_iam_user.terraform_user.name
}

resource "aws_iam_user_policy" "tf_user_policy" {
  name = "tf_user_policy"
  user = aws_iam_user.terraform_user.name

  policy = jsonencode({
    "Version"   = "2012-10-17"
    "Statement" = [
      {
        "Action" = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        "Resource"  = aws_iam_role.tf_automation.arn
        "Effect"    = "Allow"
        "Condition" = {
          "StringEquals" = {
            "sts:ExternalId" = "terraform"
          }
        }
      }
    ]
  })
}
