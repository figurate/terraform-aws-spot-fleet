## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| launch\_template | A launch template identifier | `any` | n/a | yes |
| name | A name associated with the spotfleet | `any` | n/a | yes |
| vpc\_default | Indicate whether to deploy in the default VPC | `bool` | `true` | no |
| vpc\_tags | A map of tags to match on the VPC lookup | `map(any)` | `{}` | no |

## Outputs

No output.

