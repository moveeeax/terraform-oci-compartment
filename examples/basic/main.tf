provider "oci" {}

module "compartment" {
  source = "../.."

  parent_compartment_id = var.parent_compartment_id
  name                  = "example-team"
  description           = "Example team compartment"

  # This example creates a throwaway sandbox compartment, so opt in to deletion
  # on destroy. Leave enable_delete at its default (false) for anything real.
  enable_delete = true

  freeform_tags = {
    Environment = "sandbox"
    ManagedBy   = "terraform"
  }
}

variable "parent_compartment_id" {
  description = "Parent compartment or tenancy OCID for the example compartment."
  type        = string
}

output "compartment_id" {
  value = module.compartment.id
}
