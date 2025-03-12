module "app" {
  source = "./modules/app"

  web_hash_service_config = {
    namespace        = local.config.app.web_hash_service_config.namespace
    create_namespace = local.config.app.web_hash_service_config.create_namespace
    image_config     = local.config.app.web_hash_service_config.image_config
  }

  dynamodb_config = {
    region                        = local.config.global.region
    table_name                    = local.config.app.dynamodb_config.table_name
    read_capacity                 = local.config.app.dynamodb_config.read_capacity
    write_capacity                = local.config.app.dynamodb_config.write_capacity
    environment                   = local.config.global.environment
    enable_point_in_time_recovery = local.config.app.dynamodb_config.enable_point_in_time_recovery
  }

  pod_identity_config = {
    cluster_name         = module.eks.eks.name
    namespace            = local.config.app.web_hash_service_config.namespace
    service_account_name = "${local.config.app.web_hash_service_config.namespace}-svc"

  }

  depends_on = [
    module.network,
    module.ecr_repository,
    module.eks
  ]

}