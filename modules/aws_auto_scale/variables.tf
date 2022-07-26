variable iType {
    default = "t2.micro"
    description = "ec2 instance size"
}

variable keyname {
    default = "webserver-key"
}

variable sshPub {
    default = ""
}

variable subnet {
    default = "subnet-0beea67bf6470d712"
}

variable securityGroup {
}

variable userData {
    default = ""
    description = "Script for the ec2 instance to run at launch"
}

variable tags {
    default = { Name = "Webserver" }
    description = "Tags to apply to created resources"
}