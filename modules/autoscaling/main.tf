resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
              # Update system packages
              yum update -y
              
              # Install Apache
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create a simple index page with instance metadata
              INSTANCE_ID=$${curl -s http://169.254.169.254/latest/meta-data/instance-id}
              AVAILABILITY_ZONE=$${curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone}
              
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
              
              # Ensure proper permissions
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html
              EOF
  )

  tags = var.common_tags
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