variable "name_prefix" {
  description = "Prefix of resources"
  type        = string
  default     = "cubeware"
}


variable "region" {
  description = "Region were VPC will be created"
  type        = string
  default     = "eu-central-1"
}


variable "cidr" {
  description = "CIDR range of VPC. eg: 172.16.0.0/16"
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  type        = list(string)
  description = "A list of public subnet CIDRs to deploy inside the VPC."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "private_subnet_cidrs" {
  description = "A list of private subnet CIDRs to deploy inside the VPC. Should not be higher than public subnets count"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

}


variable "extra_tags" {
  description = "Extra tags that will be added to VPC, DHCP Options, Internet Gateway, Subnets and Routing Table."
  type        = map(string)
  default     = {}
}


variable "nat_gateway_extra_tags" {
  description = "Extra tags that will be applied to nat gateway"
  type        = map(string)
  default     = {}
}


variable "enable_dns_hostnames" {
  default     = true
  description = "boolean, enable/disable VPC attribute, enable_dns_hostnames"
  type        = string
}


variable "enable_dns_support" {
  default     = true
  description = "boolean, enable/disable VPC attribute, enable_dns_support"
  type        = string
}


variable "dns_servers" {
  default     = ["AmazonProvidedDNS"]
  description = "list of DNS servers"
  type        = list(string)
}


variable "enable_nat_gateway" {
  default     = true
  description = "Enable nat gateway for every private subnet"
  type        = bool
}


variable "enable_bastion_host" {
  default     = true
  description = "Enable bastion host in first public subnet"
  type        = bool
}


variable "bastion_instance_type" {
    default = "t2.nano"
    description = "The AWS EC2 instance type"
    type = string
}


variable "bastion_volume_size" {
  default = 8
  type = number
  description = "How many GB will be the volume size?"
}


variable "bastion_ssh_keypath" {
  default = ".ssh/id_rsa.pub"
  description = "The path to the public ssh key that you will use to login"
  type        = string
}


variable "bastion_ssh_port" {
  default = 22
  type = number
  description = "The TCP port where the ssh service will listen"
}

variable "remote_device_ip" {
  description = "The public IP address of the remote (client) device"
  type        = string

}


variable "enable_ipsec_vpn" {
  default = false
  type = bool
  description = "Enable/Disable switch for provisioning the vpn infrastructure"
}


variable "bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
  default     = "65000"
  type        = string
}


variable "connection_type" {
  description = "The type of VPN connection. The only type AWS supports at this time is `ipsec.1`"
  default     = "ipsec.1"
  type        = string
}


variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP"
  default     = true
  type        = string
}


variable "static_routes" {
  description = "The list of CIDR blocks to create static routes for"
  type        = list(string)
  default     = []
}
