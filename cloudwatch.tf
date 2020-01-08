// Scale out
resource "aws_autoscaling_policy" "scale_out_jenkins_slaves" {
  name                   = "scale-out-jenkins-slaves"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.jenkins_slaves.name}"
}
resource "aws_cloudwatch_metric_alarm" "high_cpu_slaves_alarm" {
  alarm_name          = "high-cpu-jenkins-slaves-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.jenkins_slaves.name}"
  }

  alarm_description = "This metric monitors jenkins slaves cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_out_jenkins_slaves.arn}"]
}

// Scale In
resource "aws_autoscaling_policy" "scale_in_jenkins_slaves" {
  name                   = "scale-in-jenkins-slaves"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.jenkins_slaves.name}"
}
resource "aws_cloudwatch_metric_alarm" "low_cpu_jenkins_slaves_alarm" {
  alarm_name          = "low-cpu-jenkins-slaves-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.jenkins_slaves.name}"
  }

  alarm_description = "This metric monitors jenkins slaves cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_in_jenkins_slaves.arn}"]
}
