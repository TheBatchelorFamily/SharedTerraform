output "aws_eip" {
    description = "The ID value for the created elastic IP"
    value = aws_eip.webserver.public_ip
}

output "aws_eip_alloID" {
    description = "The elastic allocation ID"
    value = aws_eip.webserver.allocation_id
}

output "aws_security_group_id" {
    description = "The ID value for the created security group"
    value = aws_security_group.webserver-sg.id
}