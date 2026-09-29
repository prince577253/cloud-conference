# This main.tf uses a local_file resource to simulate provisioning
# In a real scenario, you would use aws_instance, azurerm_virtual_machine, etc.

resource "local_file" "demo_infrastructure_summary" {
  content  = <<-EOT
    Infrastructure Provisioning Summary for Cloud Conference 2026
    Environment: ${var.environment}
    Node Count: ${var.node_count}
    Instance Type: ${var.instance_type}
    
    (This is a safe local demo. In a production environment, this would provision actual cloud resources.)
  EOT
  filename = "${path.module}/infrastructure_summary.txt"
}
