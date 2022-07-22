output "aws_webserver_spot_instance_id" {
    value = aws_autoscaling_group.mygroup.spot
}