output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "Open http://<this-ip> in browser"
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}

output "rds_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}
