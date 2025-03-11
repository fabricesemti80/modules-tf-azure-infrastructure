output "availability_set_ids" {
  description = "Map of availability set names to their IDs"
  value       = { for k, v in azurerm_availability_set.avset : k => v.id }
}

output "availability_sets" {
  description = "Map of all availability set resources"
  value       = azurerm_availability_set.avset
}
