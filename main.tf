module "vpc" {
  source = "./modules/vpc"

  name_prefix     = "magento"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}

module "security_groups" {
  source              = "./modules/security_groups"
  name_prefix         = "magento"
  vpc_id              = module.vpc.vpc_id
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2_instances" {
  source               = "./modules/ec2_instances"
  admin_ami_id         = "ami-035dd7fc60ed66665"
  ami_id               = "ami-0a7d80731ae1b2435"  # Ubuntu 22.04 in us-east-1
  key_name             = "magento-key"
  bastion_subnet_id    = module.vpc.public_subnet_ids[0]
  varnish_subnet_id    = module.vpc.public_subnet_ids[0]
  admin_subnet_id      = module.vpc.private_subnet_ids[0]
  security_group_ids   = [
    module.security_groups.bastion_sg_id,
    module.security_groups.varnish_sg_id,
    module.security_groups.app_sg_id,
  ]
}

module "app_launch_template" {
  source              = "./modules/launch_template"
  ami_id              = "ami-035dd7fc60ed66665"   # <- Replace with your custom Magento AMI
  key_name            = "magento-key"
  security_group_ids  = [module.security_groups.app_sg_id]  # Replace with your SG output
  volume_size         = 100
  # user_data         = local.backup_user_data  # Optional
  # iam_instance_profile = module.ec2_iam_role.instance_profile_name  # Optional
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1]]
  alb_security_group_id = module.security_groups.alb_sg_id

  varnish_target_ip     = module.ec2_instances.varnish_private_ip
  admin_target_ip       = module.ec2_instances.admin_private_ip
}


module "app_asg" {
  source                   = "./modules/asg"
  launch_template_id       = module.app_launch_template.launch_template_id
  launch_template_version  = module.app_launch_template.launch_template_latest_version
  subnet_ids               = [module.vpc.private_subnet_ids[0]]

  min_size                 = 1
  max_size                 = 3
  desired_capacity         = 2

  # Uncomment below if using ALB
  #target_group_arns      = [module.nlb.target_group_arn]

  health_check_type        = "EC2" # Or "ELB" if attached to ALB
}

module "internal_nlb" {
  source               = "./modules/nlb"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = [module.vpc.private_subnet_ids[0]]
  asg_name             = module.app_asg.asg_name
  target_group_port    = 8080
  target_group_protocol = "TCP"
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
  db_sg_id           = module.security_groups.rds_sg_id

  db_name     = "magentodb"
  db_username = "admin"
  db_password = "codilar1234" # Replace or use secrets manager
}

module "efs" {
  source              = "./modules/efs"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = [module.vpc.private_subnet_ids[0]]  # Add more if needed
  app_sg_id           = module.security_groups.app_sg_id
}


resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "s3_backup" {
  source      = "./modules/s3_backup"
  bucket_name = "magento-app-backup-${random_id.bucket_suffix.hex}"
}

module "ec2_iam_role" {
  source         = "./modules/iam/ec2_role"
  s3_bucket_name = module.s3_backup.bucket_name
}

#locals {
#  backup_user_data = templatefile("${path.module}/scripts/backup_userdata.sh.tpl", {
#    s3_bucket_name = module.s3_backup.bucket_name
#  })
#}

