#Creating public hosted zones
resource "aws_route53_zone" "public_zones" {
  name    = var.public_domain
  comment = var.domain_comment
  tags = merge(
    local.tags,
    {
      "name"         = var.public_domain
      "cluster_type" = "both"
    }
  )
}
