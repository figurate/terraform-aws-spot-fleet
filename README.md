# AWS Spot Fleet

![AWS Spot Fleet](aws\_spot\_fleet.png)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| fleet\_desired | Desired number of instances in the ASG | `number` | `0` | no |
| fleet\_max | Maximum number of instances required in the ASG | `number` | `0` | no |
| fleet\_min | Minimum number of instances required in the ASG | `number` | `0` | no |
| launch\_template | A launch template identifier | `any` | n/a | yes |
| name | A name associated with the spotfleet | `any` | n/a | yes |
| subnets | Subnets to deploy into | `any` | `null` | no |
| vpc | Name of the VPC to deploy to | `any` | `null` | no |

## Outputs

No output.

