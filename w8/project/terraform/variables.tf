variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "alb_subnet_cidr" {
  description = "ALB public subnet CIDR block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ec2_subnet_cidr" {
  description = "EC2 public subnet CIDR block"
  type        = string
  default     = "10.0.3.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "docker_image" {
  description = "Docker image for K8s deployment"
  type        = string
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Application port inside container"
  type        = number
  default     = 80
}

variable "nodeport" {
  description = "Kubernetes NodePort"
  type        = number
  default     = 30080
}
