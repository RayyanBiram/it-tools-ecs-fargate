module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  route_cidr          = var.route_cidr
}

module "sg" {
  source = "./modules/sg"

  alb_ingress_port     = var.alb_ingress_port
  protocol             = var.protocol
  cidr_ipv4            = var.cidr_ipv4
  container_port       = var.container_port
  tasks_egress_port    = var.tasks_egress_port
  fargate_ingress_port = var.fargate_ingress_port
  vpc_id               = module.vpc.vpc_id
}

module "endpoints" {
  source = "./modules/endpoints"

  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
  ecs_fargate_sg_id      = module.sg.ecs_fargate_sg_id
}

module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.ecs.zone_id
}

module "alb" {
  source = "./modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_sg_id             = module.sg.alb_sg_id
  certificate_arn       = module.acm.certificate_arn
  zone_id               = data.aws_route53_zone.ecs.zone_id
  domain_name           = var.domain_name
  target_group_protocol = var.target_group_protocol
  container_port        = var.container_port
}

module "ecr" {
  source = "./modules/ecr"

  aws_region      = var.aws_region
  repository_name = var.repository_name
}

module "iam" {
  source = "./modules/iam"
}

module "ecs" {
  source = "./modules/ecs"

  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_tasks_sg_id    = module.sg.ecs_tasks_sg_id
  target_group_arn   = module.alb.target_group_arn
  repository_url     = module.ecr.repository_url
  execution_role_arn = module.iam.execution_role_arn
  container_port     = var.container_port
  image_tag          = var.image_tag
  protocol           = var.protocol
  aws_region         = var.aws_region
  cpu_size           = var.cpu_size
  memory_size        = var.memory_size
}

data "aws_route53_zone" "ecs" {
  name = var.domain_name
}
