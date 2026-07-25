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

## Destroy behaviour

`enable_delete` defaults to **`false`**, matching the OCI provider's own default. A compartment
is the blast-radius boundary for everything a team owns, so an accidental `terraform destroy`
should not take it — and the resources inside it — with it. With the default, destroy removes
the compartment from Terraform state and leaves it in place in OCI.

Set `enable_delete = true` deliberately for compartments that are genuinely ephemeral
(sandboxes, CI, review environments):

```hcl
module "sandbox" {
  source = "github.com/moveeeax/terraform-oci-compartment"

  parent_compartment_id = var.tenancy_id
  name                  = "ci-sandbox"
  description           = "Ephemeral CI compartment"
  enable_delete         = true
}
```

Note that OCI compartment deletion is asynchronous and the compartment must already be empty;
deleted compartments also keep their name reserved for a period, so re-creating with the same
name can fail.

## Validation

`name`, `description`, `parent_compartment_id` and `defined_tags` are validated at plan time
against the rules OCI enforces at apply time, so a bad value fails fast instead of halfway
through an apply:

- `name` — letters, digits, periods, hyphens and underscores only, no spaces, 1-100 characters.
- `description` — 1-400 characters, non-empty.
- `parent_compartment_id` — must be an `ocid1.compartment.` or `ocid1.tenancy.` OCID.
- `defined_tags` — keys must be in `namespace.key` form.

## Tests

```sh
terraform test
```

The suite in [`tests/`](tests) uses `mock_provider`, so it runs with no OCI credentials and no
network. `mock_provider` requires Terraform (or OpenTofu) >= 1.7; the module itself still
supports >= 1.5.

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
| `enable_delete`         | Whether Terraform may delete the compartment on destroy.           | `bool`        | `false` |    no    |
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
