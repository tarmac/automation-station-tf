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
    }
}