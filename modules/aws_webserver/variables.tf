variable iType {
    default = "t2.micro"
    description = "ec2 instance size"
}
variable keyname {
    default = "webserver-key"
}
variable sshIP {
    default = ["136.37.117.0/24"]
}
variable sshPub {
    default = ""
}
variable subnet {
    default = "subnet-0beea67bf6470d712"
}
variable vpc {
    default = "vpc-00a0663f397146f3d"
}
variable userData {
    default = ""
    description = "Script for the ec2 instance to run at launch"
}
variable tags {
    default = { Name = "Webserver" }
    description = "Tags to apply to created resources"
}