resource "helm_release" "xbrain" {
  name             = "xbrain"
  chart            = "${path.module}/../helm-chart"
  namespace        = "default"
  create_namespace = false

  values = [
    yamlencode({
      replicaCount = 2
      image = {
        repository = split(":", var.docker_image)[0]
        tag        = split(":", var.docker_image)[1]
      }
      service = {
        nodePort = var.nodeport
      }
    })
  ]

  depends_on = [aws_instance.ec2]
}

output "helm_release_name" {
  value       = helm_release.xbrain.name
  description = "Helm release name"
}

output "helm_release_status" {
  value       = helm_release.xbrain.status
  description = "Helm release status"
}
