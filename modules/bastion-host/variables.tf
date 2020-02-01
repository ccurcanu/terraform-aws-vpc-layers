variable "enable_bastion_host" {
  description = "Boolean to enable creation of bastion host"
  type        = bool
  default     = true
}


variable "vpc_id" {
  description = "VPC ID where bastion host will be placed in"
  type        = string
}


variable "name_prefix" {
  description = "Project name. It will be prepended to route tables."
  type        = string
}


variable "extra_tags" {
  default     = {}
  description = "Any extra tags to assign to route tables"
  type        = map(string)
}


variable "instance_type" {
  description = "Instance type"
  type        = string
}


variable "ssh_pubkey_path" {
  description = "SSH Public Key"
  type        = string
}


variable "volume_size" {
  description = "SSH Public Key"
  type        = number
}


variable "subnet_id" {
  description = "ID of subnet where to place the bastion host"
  type        = string
}


variable "ssh_port" {
  description = "SSH Port"
  type        = number
}
