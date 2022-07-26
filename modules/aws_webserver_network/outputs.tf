output "aws_eip" {
    value = aws_eip.webserver.public_ip
}

output "aws_eip_alloID" {
    value = aws_eip.webserver.allocation_id
}