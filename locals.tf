locals {
  yaml_data = { for item in fileset("${path.module}/config", "*.yaml") : (item) => yamldecode(file("${path.module}/config/${item}")) }
  config    = merge(values(local.yaml_data)...)
}