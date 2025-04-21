output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "application_url" {
  description = "URL of the application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "verification_instructions" {
  description = "Instructions to verify the setup"
  value       = <<-EOF
    🚀 Your application is now deployed! To verify:

    1. Wait a few minutes for the instances to initialize
    2. Open this URL in your browser:
       http://${module.alb.alb_dns_name}

    You should see a webpage showing:
    - Instance ID
    - Availability Zone
    - Server Time

    ⚡ Pro tip: Refresh the page multiple times to see responses from different instances!
    EOF
}
