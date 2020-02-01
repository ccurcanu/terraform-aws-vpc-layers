 provider "aws" {
   region = var.region
 }


module "vpc" {
  source               = "../modules/vpc"
  region               = var.region
  cidr                 = var.cidr
  name_prefix          = var.name_prefix
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  dns_servers          = var.dns_servers
  extra_tags           = var.extra_tags
}


module "private-subnets" {
  source      = "../modules/subnets"
  vpc_id      = module.vpc.vpc_id
  public      = false
  name_prefix = "${var.name_prefix}-private"
  cidr_blocks = var.private_subnet_cidrs
  extra_tags  = var.extra_tags
}


module "public-subnets" {
  source      = "../modules/subnets"
  vpc_id      = module.vpc.vpc_id
  name_prefix = "${var.name_prefix}-public"
  cidr_blocks = var.public_subnet_cidrs
  extra_tags  = var.extra_tags
}


module "internet-gateway" {
  source            = "../modules/internet-gateway"
  vpc_id            = module.vpc.vpc_id
  name_prefix       = "${var.name_prefix}-public"
  extra_tags        = var.extra_tags
  public_subnet_ids = module.public-subnets.ids
}


module "nat-gateway" {
  source             = "../modules/nat-gateway"
  vpc_id             = module.vpc.vpc_id
  name_prefix        = var.name_prefix
  nat_count          = length(var.public_subnet_cidrs)
  public_subnet_ids  = module.public-subnets.ids
  private_subnet_ids = module.private-subnets.ids
  extra_tags         = merge(var.extra_tags, var.nat_gateway_extra_tags)
}


module "bastion-host" {
  enable_bastion_host = var.enable_bastion_host
  source              = "../modules/bastion-host"
  name_prefix         = var.name_prefix
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.public-subnets.ids[0]
  instance_type       = var.bastion_instance_type
  volume_size         = var.bastion_volume_size
  ssh_pubkey_path     = var.bastion_ssh_keypath
  extra_tags          = var.extra_tags
  ssh_port            = var.bastion_ssh_port
}


module "vpn-ipsec" {
  enable_ipsec_vpn    = var.enable_ipsec_vpn
  name_prefix         = var.name_prefix
  source              = "../modules/vpn-ipsec"
  vpc_id              = module.vpc.vpc_id
  connection_type     = var.connection_type
  bgp_asn             = var.bgp_asn
  static_routes_only  = var.static_routes_only
  static_routes       = var.static_routes
  remote_device_ip    = var.remote_device_ip
  extra_tags          = var.extra_tags
}
