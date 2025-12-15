# SNS Topic for alerts
resource "aws_sns_topic" "webserver_alerts" {
  count = var.alert_email != "" ? 1 : 0
  name  = "webserver-alerts"
  tags  = var.tags
}

# Email subscription to SNS topic
resource "aws_sns_topic_subscription" "webserver_alerts_email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.webserver_alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Alarm for EC2 Instance Status Checks
resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  count               = var.alert_email != "" ? 1 : 0
  alarm_name          = "webserver-status-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 600
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Alert when EC2 instance fails status checks for 15+ minutes"
  alarm_actions       = [aws_sns_topic.webserver_alerts[0].arn]
  treat_missing_data  = "notBreaching"

  tags = var.tags

  depends_on = [aws_autoscaling_group.mygroup]
}
