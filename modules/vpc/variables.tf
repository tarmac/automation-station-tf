variable "cidr_block" {
  type = string
}
variable "public_subnets" {
  type = list(string)
  default = [
    "",
  ]
}
variable "private_subnets" {
  type = list(string)
  default = [
    "",
  ]
}
variable "availability_zones" {
  type = list(string)
  default = [
    "",
  ]
}

variable "tags" {
  type = map(any)
}
