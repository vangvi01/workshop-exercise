module "ecr_repository" {
  source = "./modules/ecr"

  repository_name      = local.config.ecr.repository_name
  image_tag_mutability = local.config.ecr.image_tag_mutability
  scan_on_push         = local.config.ecr.scan_on_push
  force_delete         = local.config.ecr.force_delete
  encryption_type      = local.config.ecr.encryption_type
  lifecycle_policy = try(local.config.ecr.encryption_lifecycle_policy,
    #use below policy by default if no policy is provided via config (yaml) file
    {
      enabled = true
      policy = jsonencode({
        rules = [
          {
            rulePriority = 1,
            description  = "Keep last 30 images",
            selection = {
              tagStatus   = "any",
              countType   = "imageCountMoreThan",
              countNumber = 30
            },
            action = {
              type = "expire"
            }
          }
        ]
      })
  })
  tags = try(merge(local.config.ecr.resource_tags, local.config.global.tags), local.config.global.tags)
}