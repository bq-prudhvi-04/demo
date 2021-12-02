resource "aws_launch_template" "LT_worker" {
  name_prefix   = "webserver"
  image_id      = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"
  key_name = "demo"
  vpc_security_group_ids = [var.security_groups]

}

resource "aws_autoscaling_group" "worker" {
  #availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  vpc_zone_identifier = var.private_subnet
  launch_template {
    id      = aws_launch_template.LT_worker.id
  
  }
}


resource "aws_autoscaling_policy" "worker" {
  
  name                   = "worker"
  autoscaling_group_name = aws_autoscaling_group.worker.name
  policy_type             = "TargetTrackingScaling"
 
   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}