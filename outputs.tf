output "id" {
  description = "OCID of the compartment."
  value       = oci_identity_compartment.this.id
}

output "name" {
  description = "Name of the compartment."
  value       = oci_identity_compartment.this.name
}

output "state" {
  description = "Lifecycle state of the compartment."
  value       = oci_identity_compartment.this.state
}

output "is_accessible" {
  description = "Whether the compartment is accessible to the caller."
  value       = oci_identity_compartment.this.is_accessible
}
