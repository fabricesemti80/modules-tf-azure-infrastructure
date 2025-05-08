locals {
  # Process databases to handle both string and object types, and handle empty databases
  databases = merge([
    for instance_key, instance in var.managed_instances : {
      for db_key, db in instance.databases : "${instance_key}-${db_key}" => {
        name                       = try(db.name, db) # If db is a string, use it as name; otherwise use db.name
        instance_key               = instance_key
        short_term_retention_days  = try(db.short_term_retention_days)
        long_term_retention_policy = try(db.long_term_retention_policy)
      }
    } if length(coalesce(instance.databases, {})) > 0 # Only process if databases exist and are not empty
  ]...)
}
