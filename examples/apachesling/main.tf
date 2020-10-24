module "spot_fleet" {
  source = "../.."

  name = var.name
  launch_template = var.launch_template
  fleet_min = var.fleet_min
  fleet_max = var.fleet_max
  fleet_desired = var.fleet_desired
}
