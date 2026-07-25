variable "parent_compartment_id" {
  description = "OCID of the parent compartment (or tenancy) under which to create the compartment."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.", var.parent_compartment_id))
    error_message = "parent_compartment_id must be a compartment or tenancy OCID (starting with \"ocid1.compartment.\" or \"ocid1.tenancy.\")."
  }
}

variable "name" {
  description = "Name of the compartment (unique within the parent). Letters, digits, periods, hyphens and underscores only; no spaces; 1-100 characters."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.name))
    error_message = "name must contain only letters, digits, periods, hyphens and underscores, and no spaces. OCI rejects other characters at apply time."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 100
    error_message = "name must be between 1 and 100 characters."
  }
}

variable "description" {
  description = "Description of the compartment. OCI requires a non-empty value of at most 400 characters."
  type        = string

  validation {
    condition     = length(var.description) >= 1 && length(var.description) <= 400
    error_message = "description must be between 1 and 400 characters. OCI requires a description and rejects empty values at apply time."
  }
}

variable "enable_delete" {
  description = <<-EOT
    Whether Terraform is allowed to delete the compartment on destroy. Defaults to false,
    matching the OCI provider's own default: a compartment is the blast-radius boundary for
    everything a team owns, so `terraform destroy` should not remove it by accident. With
    false, destroy only drops the compartment from state and leaves it in place. Set to true
    deliberately for ephemeral compartments (sandboxes, CI, review environments).
  EOT
  type        = bool
  default     = false
}

variable "freeform_tags" {
  description = "Free-form tags applied to the compartment."
  type        = map(string)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags applied to the compartment, keyed as \"namespace.key\"."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.defined_tags) : can(regex("^[^.]+\\.[^.]+$", k))])
    error_message = "defined_tags keys must be in \"namespace.key\" form, e.g. \"Operations.CostCenter\"."
  }
}
