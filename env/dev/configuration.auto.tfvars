config = {

  ## Provider variables
  region  = "us-east-1"
  #profile = "automation"


  ## Environment variables
  tags = {
    "Environment" : "dev"
    "Product" : "automation-station"
    "CostCentre" : "mvp"
    "GithubURL" : "https://github.com/tarmac/automation-station-tf"
  }

  ## IAM variables
  gh_oidc_role_access_policy = ""
 

  ## Secrets Manager variables
  recovery_window_in_days = "30"

  environment             = "dev"
  ecs_task_execution_role = ""
  ecs_task_role           = ""

  ## ECS variables
  ecs_cluster_name = "ecs-automation-dev"
  exec_command     = false

  services = {

    ##### SERVICE NAME #####
    automation-service = {
      type                = "public"
      service             = "automation-station"
      name                = "automation-station-server"
      cpu                 = 512
      memory              = 2048
      target_group_prefix = "dev-automation-tg" ## can't be longer than 6 characters
      max_capacity        = 3                #autoscaling max capacity
      min_capacity        = 1                #autoscaling min capacity
      healthcheck_path    = "/api"

      taskDefinitionValues = {
        image          = "785700991304.dkr.ecr.us-east-1.amazonaws.com/dev-server"
        container_name = "automation-station"
        container_port = 4200
        host_port      = 4200
        awslogs-region = "us-east-1"
        awslogs-group  = "/ecs/dev/automation-station-server"
        secrets        = <<EOF
                [

                ]
                EOF
        # Container ports to expose

        portMappings = <<EOF
                [
                    {
                        "hostPort": 4200,
                        "protocol": "tcp",
                        "containerPort": 4200
                    }
                ]
                EOF
      }
    }
  }

  ## Load balancer variables
  load_balancer_name                = "application-load-balancer"
  load_balancer_internal            = false
  load_balancer_type                = "application"
  load_balancer_deletion_protection = false
  load_balancer_log_prefix          = "lb-log"
  load_balancer_log_enabled         = true
  load_balancer_bucket_log_name     = "default-load-balancer-log-dev"
  alb_priority                      = 99
  dns_zone                          = ""
  certificate_domain                = "*.usetrace.com"
  app_certificate_domain            = ""

  ## VPC variables
  vpc_config = {
    vpc_cidr_block                          = "10.1.0.0/16"
    subnet_availability_zone                = ["us-east-1a", "us-east-1b", "us-east-1c"]
    subnet_public_map_public_ip             = true
    route_internet_gateway_destination_cidr = "0.0.0.0/0"
    default_vpc_segurity_group_name         = "default-vpc-sg"
    public_dns                              = ""
    private_dns                             = ""
  }

  ## RDS variables
  rds_config = {
    db_username             = "automation"
    db_root_password_length = 20
    db_instance_class       = "db.t3.micro"
    name                    = "dbAutomationStation"
  }

  ## s3 Bucket variables
  s3_config = {
    s3_bucket_envs                     = { "Bucket" : "internal-frontend-dev" }
    s3_bucket_name                     = "internal-frontend-dev3"
    s3_bucket_prefix                   = "dev"
    s3_bucket_acl                      = "private"
    s3_bucket_block_public_acls        = false
    s3_bucket_block_public_policy      = true
    s3_bucket_block_public_restrict    = true
    s3_bucket_block_public_ignore_acls = false
  }

  ## Cloudfront variables
  cf_config = {
    cloudfront_default_root_object = "index.html"
    cloudfront_error_code          = 403
    cloudfront_response_code       = 200
    cloudfront_response_page_path  = "/index.html"
    public_r53                     = "Z04213501KE2KE65E0HH1"
    cloudfront_origin_id           = "internal-frontend-dev.s3-us-east-1.amazonaws.com"
  }

}
