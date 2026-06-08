variable "project_name"     { type = string }
variable "env"              { type = string }
variable "instance_type"    { type = string }
variable "public_subnet_id" { type = string }
variable "ec2_sg_id"        { type = string }
variable "key_pair_name" {
  type    = string
  default = ""
}
