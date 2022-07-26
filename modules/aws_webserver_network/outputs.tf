output "aws_eip" {
    value = aws_eip.webserver.public_ip
}

output "aws_eip_alloID" {
    value = aws_eip.webserver.allocation_id
}

output "aws_security_group_id" {
    value = aws_security_group.webserver-sg.id
}