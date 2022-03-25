/**
 * # AWS Spot Fleet
 *
 * ![AWS Spot Fleet](aws_spot_fleet.png)
 */
data "aws_availability_zones" "available_zones" {}

data "aws_vpc" "vpc" {
  count = var.vpc != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
}

data "aws_subnets" "subnets" {
  count = var.vpc != null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc[0].id]
  }
  tags = {
    Name = var.subnets
  }
}

data "aws_launch_template" "spotfleet" {
  name = var.launch_template
}

data "aws_iam_role" "spotfleet" {
  name = "ecs-spotfleet-role"
}

resource "aws_spot_fleet_request" "spotfleet" {
  iam_fleet_role  = data.aws_iam_role.spotfleet.arn
  target_capacity = var.fleet_desired

  launch_template_config {
    launch_template_specification {
      id      = data.aws_launch_template.spotfleet.id
      version = data.aws_launch_template.spotfleet.latest_version
    }

    dynamic "overrides" {
      for_each = data.aws_subnets.subnets
      content {
        subnet_id = overrides.value.id
      }
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_appautoscaling_target" "spotfleet" {
  max_capacity       = var.fleet_max
  min_capacity       = var.fleet_min
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
