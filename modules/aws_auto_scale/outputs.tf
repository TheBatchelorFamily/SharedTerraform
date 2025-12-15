output "asg_name" {
  description = "The name of the autoscaling group"
  value       = aws_autoscaling_group.mygroup.name
}
output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts (empty if alerting disabled)"
  value       = try(aws_sns_topic.webserver_alerts[0].arn, "")
}