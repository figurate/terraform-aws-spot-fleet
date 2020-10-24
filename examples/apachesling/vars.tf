variable "name" {
  description = "A name associated with the spotfleet"
  default = "apachesling"
}

variable "launch_template" {
  description = "A launch template identifier"
  default = "apachesling"
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
