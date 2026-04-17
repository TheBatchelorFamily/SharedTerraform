variable "dnsName" {
  default     = "itsmeganificent.com"
  description = "The existing Route53 DNS name to use."
}

variable "r53Enabled" {
  default     = true
  description = "Enables or disables route53 components so that this module can be run without modifying dns"
}

variable "region" {
  default     = "us-east-1"
  description = "The aws region to deploy to"
}

variable "secgroupname" {
  default     = "Webserver-Sec-Group"
  description = "The name of the security group to create"
}

variable "sshIP" {
  default     = ["136.32.254.0/24"]
  description = "The subnet range that allows SSH connectivity"
}

variable "tags" {
  default     = { Name = "Webserver" }
  description = "Tags to apply to created resources"
}

variable "vpc" {
  default     = "vpc-00a0663f397146f3d"
  description = "An existing VPC ID."
}
variable "create_eip" {
  type        = bool
  default     = true
  description = "Create an IPv4 Elastic IP for the webserver. Disable this when using an IPv6-only origin."
}

variable "cloudfront_origin_domain_name" {
  type        = string
  default     = ""
  description = "Custom origin domain name for CloudFront. If empty, the module uses the EIP public DNS name."
  validation {
    condition     = var.create_eip || var.cloudfront_origin_domain_name != ""
    error_message = "Either create_eip must be true or cloudfront_origin_domain_name must be set when creating the CloudFront distribution."
  }
}
