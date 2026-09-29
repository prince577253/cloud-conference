output "summary_file_path" {
  description = "Path to the generated infrastructure summary file"
  value       = local_file.demo_infrastructure_summary.filename
}

output "deployment_environment" {
  description = "The environment being deployed"
  value       = var.environment
}
