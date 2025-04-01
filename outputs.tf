output "public_instance_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = module.ec2_public.public_instance_public_ip
}
