output "aws_webserver_spot_instance_id" {
    value = aws_spot_instance_request.webserver.spot_instance_id
}