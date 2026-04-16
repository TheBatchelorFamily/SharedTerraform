variable "dnsName" {
  type        = string
  default     = "itsmeganificent.com"
  description = "The existing Route53 DNS name to use."
}

variable "r53Enabled" {
  type        = bool
  default     = true
  description = "Enables or disables route53 components so that this module can be run without modifying dns"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The aws region to deploy to"
}

variable "secgroupname" {
  type        = string
  default     = "Webserver-Sec-Group"
  description = "The name of the security group to create"
}

variable "sshIP" {
  type        = list(string)
  default     = ["136.32.254.0/24"]
  description = "The subnet range that allows SSH connectivity"
}

variable "tags" {
  type        = map(string)
  default     = { Name = "Webserver" }
  description = "Tags to apply to created resources"
}

variable "vpc" {
  type        = string
  default     = "vpc-00a0663f397146f3d"
  description = "An existing VPC ID."
}