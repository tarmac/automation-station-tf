variable "projectname" {
  default = "internal"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "key_pair" {
  default = "automation"
}

variable "engine" {
  default = "aurora-mysql"
}
variable "engine_mode" {
  default = "serverless"
}

variable "engine_version" {
  default = "5.7.mysql_aurora.2.08.3"
}
variable "availability_zones" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "database_name" {
  default = "dbAutomationStation"
}

variable "master_username" {
  default = "root"
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

variable "instance_class" {
  default = "db.serverless"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "static_ip" {
  default = "0.0.0.0/0"
}

variable "instance_ami" {
  default = "ami-007855ac798b5175e"
}

variable "enable_http_endpoint" {
  default = true
}

variable "skip_final_snapshot" {
  default = true
}

variable "final_snapshot_identifier" {
  default = "dev-internal-db-cluster"
}
variable "s3_bucket_name" {
  default = "frontend1" 
}

variable "cloudfront_default_root_object" {
  default = "index.html"
}

variable "s3_bucket_acl" {
  default = "private"
}
variable "config" {
  type = any
}
