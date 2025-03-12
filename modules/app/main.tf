module "web-hash-service" {
  source = "./web-hash-service"

  create_namespace     = var.web_hash_service_config.create_namespace
  namespace            = var.web_hash_service_config.namespace
  image_config         = var.web_hash_service_config.image_config
  service_account_name = var.pod_identity_config.service_account_name
  iam_role_arn         = module.pod-identity.messagehash_store_role_arn

  depends_on = [
    module.dynamodb,
    module.pod-identity
  ]
}


module "dynamodb" {
  source = "./dynamodb"

  table_name                    = var.dynamodb_config.table_name
  region                        = var.dynamodb_config.region
  read_capacity                 = var.dynamodb_config.read_capacity
  write_capacity                = var.dynamodb_config.write_capacity
  environment                   = var.dynamodb_config.environment
  enable_point_in_time_recovery = var.dynamodb_config.enable_point_in_time_recovery

}

module "pod-identity" { ## this is to configure permissions for app pods in eks to access dynamoDB
  source = "./pod-identity"

  cluster_name         = var.pod_identity_config.cluster_name
  service_account_name = var.pod_identity_config.service_account_name
  namespace            = var.pod_identity_config.namespace
  table_name           = var.dynamodb_config.table_name
  region               = var.dynamodb_config.region

}