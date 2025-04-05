output "primary_endpoint" {
  description = "Primary RDS endpoint"
  value       = aws_db_instance.primary.endpoint
}

output "replica_endpoint" {
  description = "Replica RDS endpoint"
  value       = aws_db_instance.replica.endpoint
}