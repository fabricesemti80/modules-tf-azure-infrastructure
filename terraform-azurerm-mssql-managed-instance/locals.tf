

locals {
  databases = merge([
    for instance_key, instance in var.managed_instances : {
      for db_key, db in instance.databases : "${instance_key}-${db_key}" => {
        name         = db
        instance_key = instance_key
      }
    }
  ]...)
}
