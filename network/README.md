## AWS VPC

What will be provisioned:
* VPC
* Public and private subnets
* NAT Gateways for each private subnet (if set in tfvars file)
* Internet Gateway
* Bastion Host (enabled by default)
* IPsec VPN (disabled by default)


## How to use it

Provision the infrastructure:

```make network # into network or root folder```

Cleanup everything:

```make cleanup # into network or root folder```
