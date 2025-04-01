output "instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public_instance.id
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public_instance.public_ip
}

