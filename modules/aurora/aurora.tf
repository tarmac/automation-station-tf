resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster"
  engine                  = var.cluster_engine #aurora-mysql
  engine_version          = var.engine_version #13.8
  engine_mode             = var.engine_mode #provisioned
  availability_zones      = var.availability_zones
  database_name           = var.database_name #DB_Name on creation
  master_username         = var.master_username
  master_password         = random_password.root-password.result
  backup_retention_period = var.backup_retention_period #7
  storage_encrypted       = var.storage_encrypted #true
  apply_immediately       = var.apply_immediately #true
  vpc_security_group_ids  = [aws_security_group.aurora_vpc_security_group.id]
  kms_key_id              = aws_kms_key.db_cluster.arn
  db_subnet_group_name    = aws_db_subnet_group.db_cluster_subnet_group.name
  enable_http_endpoint    = var.enable_http_endpoint

  serverlessv2_scaling_configuration {
    max_capacity = var.serverless_scaling_configuration_max_capacity #3.0
    min_capacity = var.serverless_scaling_configuration_min_capacity #0.5
  }
}

resource "aws_db_subnet_group" "db_cluster_subnet_group" {
  name       = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster-subnet"
  subnet_ids = var.cluster_subnet_database_id
  tags       = var.tags
}

resource "random_password" "root-password" {
  length           = var.cluster_root_password_length
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_kms_key" "db_cluster" {
  is_enabled  = true
  description = "Encryption key for Aurora Cluster"
  policy      = data.aws_iam_policy_document.db_cluster_kms_key_policy.json
}

resource "aws_kms_alias" "db_cluster" {
  name          = "alias/${var.tags["env"]}-db-cluster"
  target_key_id = aws_kms_key.db_cluster.arn
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  identifier           = "${var.tags["env"]}-${var.tags["projectname"]}-instance"
  instance_class       = var.instance_class #db.serverless
  cluster_identifier   = aws_rds_cluster.db_cluster.id
  engine               = aws_rds_cluster.db_cluster.engine
  engine_version       = aws_rds_cluster.db_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.db_cluster_subnet_group.name
}
