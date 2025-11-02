output "project_name" {
  value = var.project_name
}

output "apps_names" {
  value = [for a in var.apps : a.name]
}
