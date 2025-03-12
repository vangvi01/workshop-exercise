resource "helm_release" "web-hash-service" {
  name = "web-hash-service"

  chart            = "${path.module}/charts" # Local chart path
  namespace        = var.namespace
  create_namespace = var.create_namespace
  set {
    name  = "image.registry"
    value = var.image_config.registry
  }
  set {
    name  = "image.repository"
    value = var.image_config.repository
  }
  set {
    name  = "image.tag"
    value = var.image_config.tag
  }
  set {
    name  = "service_account_name"
    value = var.service_account_name
  }
  set {
    name  = "iam_role_arn"
    value = var.iam_role_arn
  }

}
