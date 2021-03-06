variable "name" {
  description = "A name associated with the spotfleet"
}

variable "launch_template" {
  description = "A launch template identifier"
}

variable "fleet_min" {
  description = "Minimum number of instances required in the ASG"
  default     = 0
}

variable "fleet_max" {
  description = "Maximum number of instances required in the ASG"
  default     = 0
}

variable "fleet_desired" {
  description = "Desired number of instances in the ASG"
  default     = 0
}

variable "vpc" {
  description = "Name of the VPC to deploy to"
  default     = null
}

variable "subnets" {
  description = "Subnets to deploy into"
  default     = null
}
