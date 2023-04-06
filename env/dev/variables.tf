variable "projectname" {
  default = "internal"
}

variable "profile" {
  default = "automation"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "key_pair" {
  default = "automtion"
}

variable "cluster_engine" {
  default = "aurora-mysql"
}

variable "engine_version" {
  default = "5.7.mysql_aurora.2.03.2"
}

variable "database_name" {
  default = "db-automation-station"
}

variable "master_username" {
  default = "db_master_username"
}

variable "backup_retention_period" {
  default = "7"
}

variable "storage_encrypted" {
  default = true
}

variable "apply_immediately" {
  default = true
}

variable "serverless_scaling_configuration_max_capacity" {
  default = "3.0"
}

variable "serverless_scaling_configuration_min_capacity" {
  default = "0.5"
}

variable "instance_class" {
  default = "db.serverless"
}

variable "engine_mode" {
  default = "provisioned"
}
variable "instance_type" {
  default = "t3.micro"
}

variable "static_ip" {
  default = "0.0.0.0/0"
}

variable "instance_ami" {
  default = "ami-0735c191cf914754d"
}

variable "enable_http_endpoint" {
  default = "true"
}
