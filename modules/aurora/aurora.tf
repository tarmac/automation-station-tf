resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster"
  engine                  = var.engine
  engine_mode             = var.engine_mode 
  engine_version          = var.engine_version
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  master_password         = random_password.root-password.result
  backup_retention_period = var.backup_retention_period 
  storage_encrypted       = var.storage_encrypted
  apply_immediately       = var.apply_immediately
  vpc_security_group_ids  = [aws_security_group.aurora_vpc_security_group.id]
  kms_key_id              = aws_kms_key.db_cluster.arn
  db_subnet_group_name    = aws_db_subnet_group.db_cluster_subnet_group.name
  enable_http_endpoint    = var.enable_http_endpoint
  scaling_configuration {
    auto_pause                = var.auto_pause
    min_capacity              = var.min_capacity #1
    max_capacity              = var.max_capacity #4
    seconds_until_auto_pause  = var.seconds_until_auto_pause #300
    timeout_action            = "ForceApplyCapacityChange"
  }

  tags = {
    Name = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster-server-eip"
    Managed_by = "terraform"
  }

  lifecycle {
    ignore_changes = [
      availability_zones
    ]
  }
}

resource "aws_db_subnet_group" "db_cluster_subnet_group" {
  name       = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster-subnet"
  subnet_ids = var.cluster_subnet_database_id
  tags = {
    Name = "${var.tags["env"]}-${var.tags["projectname"]}-db-cluster-subnets"
    Managed_by = "terraform"
  }
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
