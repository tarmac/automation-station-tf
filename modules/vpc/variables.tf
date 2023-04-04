variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "tags" {
  type        = map(any)
}

variable "subnet_availability_zone" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1b", "us-east-1c"]
}
variable "subnet_public_cidr_block" {
  type = list(string)
  default = [
    "",
  ]
}
variable "subnet_private_cidr_block" {
  type = list(string)
  default = [
    "",
  ]
}
variable "subnet_database_cidr_block" {
  type = list(string)
  default = [
    "",
  ]
}