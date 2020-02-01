
output "bastion_public_ip" {
  value       =  aws_eip.bastion.*.public_ip
  description = "Bastion public IP address"
}
