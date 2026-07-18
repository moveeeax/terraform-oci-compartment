variable "parent_compartment_id" {
  description = "OCID of the parent compartment (or tenancy) under which to create the compartment."
  type        = string
}

variable "name" {
  description = "Name of the compartment (unique within the parent)."
  type        = string
}

variable "description" {
  description = "Description of the compartment."
  type        = string
}

variable "enable_delete" {
  description = "Whether Terraform is allowed to delete the compartment on destroy."
  type        = bool
  default     = true
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
}
