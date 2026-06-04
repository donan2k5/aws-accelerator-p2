resource "aws_security_group" "ec2" {
  name        = "${local.environment_name}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.environment_name}-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2.id

  description = "SSH from anywhere"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_nodeport" {
  security_group_id = aws_security_group.ec2.id

  description              = "NodePort from ALB"
  from_port                = var.nodeport
  to_port                  = var.nodeport
  ip_protocol              = "tcp"
  referenced_security_group_id = aws_security_group.alb.id

  tags = {
    Name = "NodePort-from-ALB"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_all" {
  security_group_id = aws_security_group.ec2.id

  description = "All outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "All-Egress"
  }
}

resource "aws_security_group" "alb" {
  name        = "${local.environment_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.environment_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "HTTP from anywhere"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "HTTP"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ec2" {
  security_group_id = aws_security_group.alb.id

  description              = "To EC2 NodePort"
  from_port                = var.nodeport
  to_port                  = var.nodeport
  ip_protocol              = "tcp"
  referenced_security_group_id = aws_security_group.ec2.id

  tags = {
    Name = "To-EC2-NodePort"
  }
}
