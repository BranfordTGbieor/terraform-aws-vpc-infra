resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
    description     = "Allow HTTP traffic from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.common_tags
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name}-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash

              # Setup logging
              exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
              echo "[$(date)] Starting user data script..."

              # Update system packages
              echo "[$(date)] Updating system packages..."
              yum update -y
              
              # Install Apache and tools
              echo "[$(date)] Installing Apache and tools..."
              yum install -y httpd curl
              
              # Configure and start Apache
              echo "[$(date)] Configuring Apache..."
              systemctl start httpd
              systemctl enable httpd
              
              # Verify Apache is running
              echo "[$(date)] Verifying Apache status..."
              systemctl status httpd
              
              # Fetch instance metadata
              echo "[$(date)] Fetching instance metadata..."
              INSTANCE_ID=$${curl -s http://169.254.169.254/latest/meta-data/instance-id}
              AVAILABILITY_ZONE=$${curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone}
              
              # Create web content
              echo "[$(date)] Creating web content..."
              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                  <title>AWS EC2 Instance Info</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          max-width: 800px;
                          margin: 0 auto;
                          padding: 20px;
                          text-align: center;
                          background-color: #f0f0f0;
                      }
                      .container {
                          background-color: white;
                          padding: 20px;
                          border-radius: 8px;
                          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                      }
                      h1 { color: #232f3e; }
                      .info { margin: 10px 0; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>Hello from AWS EC2!</h1>
                      <div class="info">
                          <p><strong>Instance ID:</strong> $${INSTANCE_ID}</p>
                          <p><strong>Availability Zone:</strong> $${AVAILABILITY_ZONE}</p>
                          <p><strong>Server Time:</strong> $$(date)</p>
                      </div>
                  </div>
              </body>
              </html>
              HTML
              
              # Set permissions
              echo "[$(date)] Setting permissions..."
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html

              # Final Apache check
              echo "[$(date)] Testing Apache..."
              curl -s -o /dev/null -w "HTTP Response Code: %%{http_code}\n" http://localhost/
              
              echo "[$(date)] User data script completed successfully"
              EOF
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = var.name
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}