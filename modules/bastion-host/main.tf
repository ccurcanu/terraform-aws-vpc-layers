
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "ssh_key" {
  key_name   = "bastion.key-name"
  public_key = file(var.ssh_pubkey_path)
}


resource "aws_instance" "bastion" {
  count                       = var.enable_bastion_host == true ? 1: 0
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = "true"
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.0.id]

  depends_on                  = [aws_security_group.bastion]

  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
    ]
  }

  tags = merge(
    {
      "Name" = "${var.name_prefix}-bastion"
    },
    var.extra_tags,
  )

  user_data = <<END_INIT
#!/bin/bash
echo "Hello world"
END_INIT

}


resource "aws_security_group" "bastion" {
  count  = var.enable_bastion_host == true ? 1: 0
  name   = "${var.name_prefix}-bastion-sq"
  vpc_id = var.vpc_id
}


/* Open ingress trafic SSH port
 */

resource "aws_security_group_rule" "ssh_tcp" {
  count             = var.enable_bastion_host == true ? 1: 0
  depends_on        = [aws_security_group.bastion]
  type              = "ingress"
  description       = "Open Input for ${var.ssh_port} (TCP)"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion[count.index].id
}


/* Open egress trafic
 */

resource "aws_security_group_rule" "open_egress" {
  count             = var.enable_bastion_host == true ? 1: 0
  depends_on        = [aws_security_group.bastion]
  type              = "egress"
  description       = "OPEN egress, all ports, all protocols"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion[count.index].id
}


/* Generate EIP for bastion and associate it with the EC2 instance
 */

resource "aws_eip" "bastion" {
  count             = var.enable_bastion_host == true ? 1: 0
  depends_on        = [aws_instance.bastion]
  vpc               = "true"
}


resource "aws_eip_association" "bastion" {
  count             = var.enable_bastion_host == true ? 1: 0
  depends_on        = [aws_eip.bastion]
  allocation_id     = aws_eip.bastion[count.index].id
  instance_id       = aws_instance.bastion[count.index].id
}
