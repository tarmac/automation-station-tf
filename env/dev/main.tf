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
        projectname    = "internal"
    }
}
module "aurora" {
    source                      = "../../modules/aurora"
    engine_mode                 = var.engine_mode
    master_username             = var.master_username
    cluster_engine              = var.cluster_engine
    instance_class              = var.instance_class
    storage_encrypted           = var.storage_encrypted
    cluster_subnet_database_id  = var.cluster_subnet_database_id
    vpc_id                      = module.vpc.vpc_id  
    private_subnets             = module.vpc.public_subnet_ids 
    vpc_cidr                    = module.vpc.cidr_block 
    engine_version              = var.engine_version
    apply_immediately           = var.apply_immediately
    database_name               = var.database_name
    serverless_scaling_configuration_min_capacity = var.serverless_scaling_configuration_min_capacity
    serverless_scaling_configuration_max_capacity = var.serverless_scaling_configuration_max_capacity
    backup_retention_period     = var.backup_retention_period

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
    tags            = var.tags
    instance_ami    = var.instance_ami 
}

