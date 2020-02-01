/**
 * ## AWS IPSEC VPN
 *
 * This module packages the various resources needed to setup an IPSEC VPN
 * on AWS:
 *
 * * `aws_vpn_gateway`
 * * `aws_customer_gateway`
 * * `aws_vpn_connection`
 * * `aws_vpn_connection_route`
 *
 */

resource "aws_vpn_gateway" "main" {
  count = var.enable_ipsec_vpn == true ? 1: 0
  vpc_id = var.vpc_id
  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.extra_tags,
  )
}


resource "aws_customer_gateway" "main" {
  count      = var.enable_ipsec_vpn == true ? 1: 0
  ip_address = var.remote_device_ip
  bgp_asn    = var.bgp_asn
  type       = "ipsec.1"
  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.extra_tags,
  )
}


resource "aws_vpn_connection" "main" {
  count               = var.enable_ipsec_vpn == true ? 1: 0
  vpn_gateway_id      = aws_vpn_gateway.main[count.index].id
  customer_gateway_id = aws_customer_gateway.main[count.index].id
  type                = var.connection_type
  static_routes_only  = var.static_routes_only
  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.extra_tags,
  )

  /**
  * This is needed for FIPS VPN enpoints, as an un-documented `type` must be
  * provided, but AWS does not report the type back correctly. This causes an
  * erroneous change to be detected in TF.
  */
  lifecycle {
    ignore_changes = [type]
  }
}


resource "aws_vpn_connection_route" "main" {
  count = var.enable_ipsec_vpn == true ? length(var.static_routes): 0
  destination_cidr_block = element(var.static_routes, count.index)
  vpn_connection_id = aws_vpn_connection.main[count.index].id
}
