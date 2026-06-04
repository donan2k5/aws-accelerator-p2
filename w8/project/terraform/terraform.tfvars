aws_region             = "us-east-1"
vpc_cidr               = "10.0.0.0/16"
alb_subnet_cidr        = "10.0.2.0/24"
ec2_subnet_cidr        = "10.0.3.0/24"
instance_type          = "t3.medium"
docker_image           = "tuphucnguyen20051/xbrain-app:latest"
app_port               = 80
nodeport               = 30080