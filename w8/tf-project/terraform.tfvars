aws_region   = "ap-southeast-1"
project_name = "web-app"
env          = "dev"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]

instance_type  = "t3.micro"
key_pair_name  = ""          # điền tên key pair nếu cần SSH

db_name           = "appdb"
db_username       = "admin"
db_password       = "ChangeMe123!"   # đổi lại trước khi apply
db_instance_class = "db.t3.micro"
