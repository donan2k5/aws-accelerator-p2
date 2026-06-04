output "app_url" {
  value       = "http://${aws_lb.main.dns_name}"
  description = "URL to access the XBrain app"
}

output "alb_dns" {
  value       = aws_lb.main.dns_name
  description = "ALB DNS name"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "alb_subnet_id" {
  value       = aws_subnet.alb.id
  description = "ALB public subnet ID"
}

output "ec2_subnet_id" {
  value       = aws_subnet.ec2.id
  description = "EC2 public subnet ID"
}


output "deployment_status" {
  value       = "Check EC2 logs: tail -f /var/log/cloud-init-output.log"
  description = "How to check deployment status on EC2"
}
