variable "tags" {
  description = "ECS tags"
  type        = map(any)
}

variable "environment" {
  default = "dev"
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block."
  type        = string
}

variable "region" {
  type = string
}
variable "config_services" {
  type = any
  description = "All the services in the map object"
}

variable "services" {
  description = "All the services in the map object"
}

variable "aws_acc_id" {
  type = string
}

variable "ecs_task_execution_role" {

}

variable "ecs_task_role" {

}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "public_subnets" {
  description = "public_subnets"
  type        = list
}
variable "private_subnets" {
  type        = list(string)
  description = "A list of all private subnets IDs."
}

variable "exec_command" {
  # default     = false
   type        = any
  description = "Variable to turn on or off access to Fargate tasks"
}
variable "acm_certificate_arn" {
  default     = ""
  type        = string
  description = "Variable for ssl cerificate"
}