resource "random_id" "deployment" {
  byte_length = 4

  depends_on = [aws_instance.ec2]
}

output "deployment_id" {
  value       = random_id.deployment.hex
  description = "Unique deployment ID"
}

output "k8s_setup_info" {
  value = {
    status  = "K8s resources deployed via kubectl in EC2 user_data"
    minikube_nodeport = var.nodeport
    docker_image = var.docker_image
    deployment_id = random_id.deployment.hex
  }
  description = "K8s deployment info"
}
