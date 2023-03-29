terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "dev-petnanny-bucket"
    key            = "pn-terraform/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region                  = "ap-southeast-2"
  profile                 = "PNTerraform"
  shared_credentials_file = "~/.aws/credentials"
}

# Provision for petnanny backend

# Create VPC
resource "aws_vpc" "pn-server-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-pn-server-vpc"
  }
}

module "pn-server-subnet" {
  source                     = "./modules/subnet"
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zone          = var.availability_zone
  env_prefix                 = var.env_prefix
  vpc_id                     = aws_vpc.pn-server-vpc.id
}

module "pn-server-security" {
  source     = "./modules/sg"
  env_prefix = var.env_prefix
  vpc_id     = aws_vpc.pn-server-vpc.id
}

module "pn-server-acm" {
  source       = "./modules/acm"
  root_domain  = var.root_domain
  alb_dns_name = module.pn-server-alb.alb.dns_name
  alb_zone_id  = module.pn-server-alb.alb.zone_id
  env_prefix   = var.env_prefix
}

module "pn-server-alb" {
  source            = "./modules/alb"
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.pn-server-vpc.id
  health_check_path = var.health_check_path
  alb_sg_id         = module.pn-server-security.alb-sg.id
  public_subnet_id  = [module.pn-server-subnet.public-subnet[0].id, module.pn-server-subnet.public-subnet[1].id]
  certificate_arn   = module.pn-server-acm.certificate.arn
}

module "pn-server-ecs" {
  source                 = "./modules/ecs"
  env_prefix             = var.env_prefix
  vpc_id                 = aws_vpc.pn-server-vpc.id
  fargate_cpu            = var.fargate_cpu
  fargate_memory         = var.fargate_memory
  repo_url               = var.repo_url
  image_tag              = var.image_tag
  container_cpu          = var.container_cpu
  container_memory       = var.container_memory
  container_port         = var.container_port
  container_count        = var.container_count
  alb_target_group_arn   = module.pn-server-alb.alb_target_group.arn
  private_subnet_id      = [module.pn-server-subnet.private-subnet[0].id, module.pn-server-subnet.private-subnet[1].id]
  ecs_cluster_sg_id      = module.pn-server-security.ecs-cluster-sg-id
  pn-server-port         = var.pn-server-port
  ecs_dependends_on_list = module.pn-server-alb.alb_listener_https_alb
}

# Provision for petnanny frontend - s3 static website, cdn for the s3 website endpoint and create route 53 alias recored. 

module "pn-app-s3" {
  source               = "./modules/s3"
  frontend_bucket_name = var.frontend_bucket_name
  env_prefix           = var.env_prefix
}

module "pn-app-cloudfront" {
  source                         = "./modules/cloudfront"
  root_domain                    = var.root_domain
  frontend_bucket_name           = var.frontend_bucket_name
  env_prefix                     = var.env_prefix
  s3_bucket_regional_domain_name = module.pn-app-s3.bucket_regional_domain_name
}

module "pn-app-route53" {
  source                                    = "./modules/route53"
  root_domain                               = var.root_domain
  frontend_bucket_name                      = var.frontend_bucket_name
  cloudfront_s3_distribution_domian_name    = module.pn-app-cloudfront.cloudfront_s3_distribution.domain_name
  cloudfront_s3_distribution_hosted_zone_id = module.pn-app-cloudfront.cloudfront_s3_distribution.hosted_zone_id
}
