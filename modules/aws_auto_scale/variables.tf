variable iamRoleName {
    default     = "assign-eip"
    description = "Name for iam policy"
}

variable iType {
    default     = "t2.micro"
    description = "ec2 instance size"
}

variable keyname {
    default = "webserver-key"
    description = "The name of the ssh key to create"
}

variable publicIP {
    default     = false
    description = "Determines if a public IP is assigned to the instances built from the auto scale template"
}

variable sshPub {
    default = ""
    description = "The public key value for the ssh key being created"
}

variable subnet {
    default = "subnet-0beea67bf6470d712"
    description = "The subnet id of the existing subnet to use"
}

variable securityGroup {
    description = "The security group ID of the existing security group to assign"
}

variable userData {
    default     = ""
    description = "Script for the ec2 instance to run at launch"
}

variable tags {
    default     = { Name = "Webserver" }
    description = "Tags to apply to created resources"
}