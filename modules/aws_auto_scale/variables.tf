variable "iamRoleName" {
  type        = string
  default     = "assign-eip"
  description = "Name for iam policy"
}

variable "iType" {
  type        = string
  default     = "t3.micro"
  description = "ec2 instance size"
}

variable "keyname" {
  type        = string
  default     = "webserver-key"
  description = "The name of the ssh key to create"
}

variable "publicIP" {
  type        = bool
  default     = false
  description = "Determines if a public IP is assigned to the instances built from the auto scale template"
}

variable "sshPub" {
  type        = string
  default     = ""
  description = "The public key value for the ssh key being created"
}

variable "securityGroup" {
  type        = list(string)
  description = "The security group ID of the existing security group to assign"
}

variable "userData" {
  type        = string
  default     = ""
  description = "Script for the ec2 instance to run at launch"
}

variable "tags" {
  type        = map(string)
  default     = { Name = "Webserver" }
  description = "Tags to apply to created resources"
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alerts"
  type        = string
  default     = "christsreturn01@gmail.com"
}
