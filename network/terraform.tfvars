name_prefix             = "mydeployment"
region                  = "eu-central-1"
cidr                    = "10.0.0.0/16"
public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs    = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
extra_tags              = {}
enable_dns_hostnames    = true
enable_dns_support      = true
dns_servers             = ["AmazonProvidedDNS"]
enable_nat_gateway      = true
nat_gateway_extra_tags  = {}

enable_bastion_host     = true
bastion_instance_type   = "t2.nano"
bastion_volume_size     = 8
bastion_ssh_keypath     = ".ssh/id_rsa.pub"
bastion_ssh_port        = 22

enable_ipsec_vpn        = false
connection_type         = "ipsec.1"
bgp_asn                 = 65535
static_routes_only      = true
static_routes           = [] # Please find out the routes and fill this list
remote_device_ip        = "127.0.0.1" # Please find out the customer side IP address and fill this variable
