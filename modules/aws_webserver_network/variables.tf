variable dnsName {
    default = "itsmeganificent.com"
}

variable r53Enabled {
    default     = true
    description = "Enables or disables route53 components so that this module can be run without modifying dns"
}

variable region {
    default = "us-east-1"
}

variable secgroupname {
    default = "Webserver-Sec-Group"
}

variable sshIP {
    default = ["136.37.117.0/24"]
}

variable tags {
    default = { Name = "Webserver" }
    description = "Tags to apply to created resources"
}

variable vpc {
    default = "vpc-00a0663f397146f3d"
}