variable dnsName {
    default = "itsmeganificent.com"
}

variable region {
    default = "us-east-1"
}

variable secgroupname {
    default = "Webserver-Sec-Group"
}

variable spot_instance_id {
    description = "ID for EC2 spot instance"
}

variable tags {
    default = { Name = "Webserver" }
    description = "Tags to apply to created resources"
}