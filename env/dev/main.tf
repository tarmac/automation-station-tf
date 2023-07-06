module "vpc" {
    source                      = "../../modules/vpc"
    cidr_block                  = var.vpc_cidr_block
    availability_zones          = ["${var.region}a", "${var.region}b", "${var.region}c"]
    
    public_subnets = [
    cidrsubnet(var.vpc_cidr_block, 6, 0),
    cidrsubnet(var.vpc_cidr_block, 6, 1),
    cidrsubnet(var.vpc_cidr_block, 6, 2),
    ]

    private_subnets = [
    cidrsubnet(var.vpc_cidr_block, 6, 3),
    cidrsubnet(var.vpc_cidr_block, 6, 4),
    cidrsubnet(var.vpc_cidr_block, 6, 5),
    ]

    tags = {
        env            = "dev"
        vpc            = "vpc"
        projectname    = "internal-automation"
    }
}
module "aurora" {
    source                      = "../../modules/aurora"
    master_username             = var.master_username
    engine                      = var.engine
    engine_mode                 = var.engine_mode
    engine_version              = var.engine_version
    availability_zones          = var.availability_zones
    instance_class              = var.instance_class
    storage_encrypted           = var.storage_encrypted
    cluster_subnet_database_id  = module.vpc.private_subnet_ids
    vpc_id                      = module.vpc.vpc_id  
    private_subnets             = module.vpc.subnet_private_cidr
    public_subnets              = module.vpc.subnet_public_cidr
    skip_final_snapshot         = var.skip_final_snapshot
    final_snapshot_identifier   = var.final_snapshot_identifier
    apply_immediately           = var.apply_immediately
    database_name               = var.database_name
    backup_retention_period     = var.backup_retention_period
    enable_http_endpoint        = var.enable_http_endpoint

    tags = {
        env            = "dev"
        vpc            = "vpc"
        projectname    = "internal"
    }

}

module "ec2" {
    source          = "../../modules/ec2"
    vpc_id          = module.vpc.vpc_id
    vpc_cidr_block  = module.vpc.cidr_block
    public_subnets  = module.vpc.public_subnet_ids
    key_pair        = var.key_pair
    region          = var.region 
    instance_type   = var.instance_type
    static_ip       = var.static_ip
    instance_ami    = var.instance_ami 

        tags = {
        env            = "dev"
        vpc            = "vpc"
        projectname    = "internal"
    }
}

module "cloudfront" {
    source                          = "../../modules/cloudfront"
    cloudfront_default_root_object  = var.cloudfront_default_root_object
    acm_certificate_arn             = module.cloudfront.aws_acm_certificate_arn
    region                          = var.region
    s3_bucket_name                  = var.s3_bucket_name
    web_acl_arn                     = module.waf.wafv2_web_acl_cloudfront_arn
        tags = {
        env            = "dev"
        vpc            = "vpc"
        projectname    = "internal"
    }
}

module "s3" {
    source = "../../modules/s3"
    s3_bucket_name                              = var.s3_bucket_name
    s3_bucket_acl                               = var.s3_bucket_acl
    aws_acc_id                                  = data.aws_caller_identity.current.account_id
    cloudfront_distribution_arn                 = module.cloudfront.cloudfront_distribution_arn
        tags = {
        env            = "dev"
        vpc            = "vpc"
        projectname    = "internal"
    }
}

module "ecs" {
    source                  = "../../modules/ecs"
    environment             = var.environment
    vpc_id                  = module.vpc.vpc_id
    vpc_cidr_block          = var.vpc_cidr_block
    region                  = var.region
    services                = var.config.services
    config_services         = var.config.services
    aws_acc_id              = data.aws_caller_identity.current.account_id
    ecs_task_execution_role = data.aws_iam_policy_document.ecs_ecr_access.json
    ecs_task_role           = data.aws_iam_policy_document.ecs_ecr_access.json
    container_definitions   = "${path.root}/../taskdefinitions/generic_task_definition.tpl"
    public_subnets          = module.vpc.public_subnet_ids
    private_subnets         = module.vpc.subnet_private_cidr
    exec_command            = var.config.exec_command
    acm_certificate_arn     = module.cloudfront.aws_acm_certificate_arn



    tags = {
        env            = "dev"
        projectname    = "internal"
    }
}

module "waf" {
  source                         = "../../modules/waf"
#   lb_arn                         = module.ecs.lb_arn #check after creation of module ECS
  cloudfront_distribution_arn    = module.cloudfront.cloudfront_distribution_arn #check after creation of module cloudfron
  tags = {
        env            = "dev"
        projectname    = "internal"
    }
}

module "pipelines_backend" {
    source          = "../../modules/pipelines/backend"
    private_subnets  = module.vpc.subnet_private_cidr

    tags = {
        env            = "dev"
        projectname    = "internal"
    }
}
