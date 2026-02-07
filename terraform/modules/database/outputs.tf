output "rds_endpoint" { value = aws_db_instance.main.endpoint }
output "rds_address" { value = aws_db_instance.main.address }
output "database_name" { value = aws_db_instance.main.db_name }
output "secret_arn" { value = aws_secretsmanager_secret.rds.arn }
output "security_group_id" { value = aws_security_group.rds.id }
