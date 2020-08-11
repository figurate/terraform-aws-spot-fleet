variable "name" {
  description = "A name associated with the spotfleet"
}

variable "vpc_default" {
  description = "Indicate whether to deploy in the default VPC"
  default     = true
}

variable "vpc_tags" {
  type        = map(any)
  description = "A map of tags to match on the VPC lookup"
  default     = {}
}

variable "launch_template" {
  description = "A launch template identifier"
}
