data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Hello from AWS EC2</title>
      <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center;
               align-items: center; min-height: 100vh; margin: 0; background: #f0f4f8; }
        .card { background: white; padding: 40px 60px; border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; }
        h1   { color: #2563eb; }
        p    { color: #64748b; }
        .badge { display: inline-block; background: #dcfce7; color: #16a34a;
                 padding: 4px 12px; border-radius: 9999px; font-size: 0.85rem; margin-top: 8px; }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>Hello from AWS EC2!</h1>
        <p>Web App deployed with <strong>Terraform</strong></p>
        <p>Architecture: VPC + EC2 + RDS + S3</p>
        <span class="badge">Running on Amazon Linux 2023</span>
      </div>
    </body>
    </html>
    HTML
  EOF

  tags = { Name = "${var.project_name}-${var.env}-ec2-web" }
}
