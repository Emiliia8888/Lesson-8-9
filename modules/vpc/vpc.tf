module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "django-gitops-vpc"
  cidr = var.vpc_cidr

  azs = [
    "eu-central-1a",
    "eu-central-1b"
  ]

  public_subnets = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]

  private_subnets = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  manage_default_route_table = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
