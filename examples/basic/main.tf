provider "oci" {}

module "compartment" {
  source = "../.."

  parent_compartment_id = var.parent_compartment_id
  name                  = "example-team"
  description           = "Example team compartment"

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
