# Test-only requirement: `mock_provider` needs Terraform >= 1.7 (or OpenTofu >= 1.7).
# The module itself still supports >= 1.5 -- see versions.tf.
mock_provider "oci" {}

variables {
  parent_compartment_id = "ocid1.tenancy.oc1..aaaaaaaaexampleuniqueid"
  name                  = "example-team"
  description           = "Example team compartment"
}

run "destroy_is_disabled_by_default" {
  command = plan

  assert {
    condition     = oci_identity_compartment.this.enable_delete == false
    error_message = "enable_delete must default to false so `terraform destroy` cannot silently delete the compartment and everything in it."
  }
}

run "destroy_can_be_opted_into" {
  command = plan

  variables {
    enable_delete = true
  }

  assert {
    condition     = oci_identity_compartment.this.enable_delete == true
    error_message = "enable_delete = true must be honoured for ephemeral compartments."
  }
}

run "tags_propagate_to_the_compartment" {
  command = plan

  variables {
    freeform_tags = {
      Environment = "sandbox"
      ManagedBy   = "terraform"
    }
    defined_tags = {
      "Operations.CostCenter" = "42"
    }
  }

  assert {
    condition     = oci_identity_compartment.this.freeform_tags["Environment"] == "sandbox"
    error_message = "freeform_tags must reach the compartment resource."
  }

  assert {
    condition     = oci_identity_compartment.this.defined_tags["Operations.CostCenter"] == "42"
    error_message = "defined_tags must reach the compartment resource."
  }
}

run "parent_and_name_are_wired_through" {
  command = plan

  assert {
    condition     = oci_identity_compartment.this.compartment_id == var.parent_compartment_id
    error_message = "parent_compartment_id must be passed as the resource's compartment_id (the parent), not something else."
  }

  assert {
    condition     = oci_identity_compartment.this.name == "example-team"
    error_message = "name must be passed straight through."
  }
}

run "rejects_name_with_spaces" {
  command = plan

  variables {
    name = "example team"
  }

  expect_failures = [var.name]
}

run "rejects_name_with_illegal_characters" {
  command = plan

  variables {
    name = "example/team"
  }

  expect_failures = [var.name]
}

run "rejects_overlong_name" {
  command = plan

  variables {
    name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" # 101 chars
  }

  expect_failures = [var.name]
}

run "rejects_empty_description" {
  command = plan

  variables {
    description = ""
  }

  expect_failures = [var.description]
}

run "rejects_non_compartment_parent_ocid" {
  command = plan

  variables {
    parent_compartment_id = "ocid1.subnet.oc1..aaaaaaaaexampleuniqueid"
  }

  expect_failures = [var.parent_compartment_id]
}

run "rejects_defined_tag_key_without_namespace" {
  command = plan

  variables {
    defined_tags = {
      CostCenter = "42"
    }
  }

  expect_failures = [var.defined_tags]
}
