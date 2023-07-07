variable "tags" {
  type        = map(any)
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of all public subnets IDs."
}
variable "private_subnets" {
  type = list(string)
  default = [
    "",
  ]
}