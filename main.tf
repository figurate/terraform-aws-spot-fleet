data "aws_vpc" "tenant" {
  default = var.vpc_default
  tags    = var.vpc_tags
}

data "aws_availability_zones" "available_zones" {}

data "aws_subnet_ids" "tenant" {
  vpc_id = data.aws_vpc.tenant.id
}

data "aws_launch_template" "spotfleet" {
  name = var.launch_template
}

resource "aws_spot_fleet_request" "spotfleet" {
  iam_fleet_role  = ""
  target_capacity = 0

  launch_template_config {
    launch_template_specification {
      id      = data.aws_launch_template.spotfleet.id
      version = data.aws_launch_template.spotfleet.latest_version
    }

    dynamic "overrides" {
      for_each = data.aws_subnet_ids.tenant.ids
      content {
        subnet_id = overrides.value
      }
    }
  }
}

resource "aws_appautoscaling_target" "spotfleet" {
  max_capacity       = 0
  min_capacity       = 0
  resource_id        = join("/", ["spot-fleet-request", aws_spot_fleet_request.spotfleet.id])
  scalable_dimension = "ec2:spot-fleet-request:TargetCapacity"
  service_namespace  = "ec2"
}

resource "aws_appautoscaling_policy" "scale_out" {
  name               = "scale_out"
  resource_id        = aws_appautoscaling_target.spotfleet.resource_id
  scalable_dimension = aws_appautoscaling_target.spotfleet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.spotfleet.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name               = "scale_in"
  resource_id        = aws_appautoscaling_target.spotfleet.resource_id
  scalable_dimension = aws_appautoscaling_target.spotfleet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.spotfleet.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}
