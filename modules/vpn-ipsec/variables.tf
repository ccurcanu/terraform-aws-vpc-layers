variable "enable_ipsec_vpn" {
  default = false
  type = bool
  description = "Enable/Disable switch for provisioning the vpn infrastructure"
}


variable "name_prefix" {
  description = "Used to name the various VPN resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to associate the VPN with"
  type        = string
}

variable "remote_device_ip" {
  description = "The public IP address of the remote (client) device"
  type        = string
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

variable "extra_tags" {
  description = "Extra tags to append to various AWS resources"
  default     = {}
  type        = map(string)
}
