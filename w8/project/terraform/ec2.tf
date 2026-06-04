data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ec2.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = base64encode(templatefile("${path.module}/../scripts/setup.sh", {
    docker_image = var.docker_image
    nodeport     = var.nodeport
  }))

  tags = {
    Name = local.instance_name
  }

  depends_on = [aws_iam_role_policy.ec2]
}

resource "aws_iam_role" "ec2" {
  name = "${local.environment_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.environment_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy" "ec2" {
  name = "${local.environment_name}-ec2-policy"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

output "ec2_private_ip" {
  value = aws_instance.ec2.private_ip
}

output "ec2_instance_id" {
  value = aws_instance.ec2.id
}
