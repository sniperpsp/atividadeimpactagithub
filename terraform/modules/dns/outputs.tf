output "zone_id" {
  value = length(data.aws_route53_zone.main) > 0 ? data.aws_route53_zone.main[0].zone_id : ""
}

output "nameservers" {
  value = length(data.aws_route53_zone.main) > 0 ? data.aws_route53_zone.main[0].name_servers : []
}

output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "domain_name" {
  value = var.domain_name
}
