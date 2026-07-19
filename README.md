# terraform-oci-compartment

Terraform module that manages an [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/)
compartment, the fundamental unit for organising and isolating cloud resources. It can be
nested under any parent compartment or the tenancy root.

## Usage

```hcl
module "compartment" {
  source = "github.com/moveeeax/terraform-oci-compartment"

  parent_compartment_id = var.tenancy_id
  name                  = "prod"
  description           = "Production workloads"

  freeform_tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

A runnable example lives in [`examples/basic`](examples/basic).

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.5   |
| oci       | >= 5.0   |

## Inputs

| Name                    | Description                                                        | Type          | Default | Required |
|-------------------------|--------------------------------------------------------------------|---------------|---------|:--------:|
| `parent_compartment_id` | OCID of the parent compartment (or tenancy).                       | `string`      | n/a     |   yes    |
| `name`                  | Name of the compartment (unique within the parent).               | `string`      | n/a     |   yes    |
| `description`           | Description of the compartment.                                    | `string`      | n/a     |   yes    |
| `enable_delete`         | Whether Terraform may delete the compartment on destroy.           | `bool`        | `true`  |    no    |
| `freeform_tags`         | Free-form tags applied to the compartment.                         | `map(string)` | `{}`    |    no    |
| `defined_tags`          | Defined tags applied to the compartment, keyed `namespace.key`.    | `map(string)` | `{}`    |    no    |

## Outputs

| Name            | Description                                     |
|-----------------|-------------------------------------------------|
| `id`            | OCID of the compartment.                        |
| `name`          | Name of the compartment.                        |
| `state`         | Lifecycle state of the compartment.             |
| `is_accessible` | Whether the compartment is accessible.          |

## License

[MIT](LICENSE)
