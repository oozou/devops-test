locals {
  vpn_name            = "devops"
  authentication_type = "certificate-authentication"
  organization_name   = "johnnii-dev"
  allowed_cidr_ranges = [var.cidr_range_workload, var.vpc_cidr_ingress]
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = "${local.vpn_name}-client-vpn"
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = "172.16.0.0/22"
  split_tunnel           = true
  dns_servers            = ["8.8.8.8", "1.1.1.1"]

  self_service_portal = "disabled"
  vpc_id              = module.ingress_vpc.vpc_id
  security_group_ids = [
    module.https_vpn_sg.security_group_id,
    module.kubernetes_vpn_sg.security_group_id,
  ]

  authentication_options {
    type                       = local.authentication_type
    root_certificate_chain_arn = local.authentication_type != "certificate-authentication" ? null : aws_acm_certificate.root.arn
  }


  connection_log_options {
    enabled = false
  }

  tags = merge(
    var.tags,
    tomap({
      "Name"    = "${local.vpn_name}-client-vpn",
      "EnvName" = local.vpn_name
    })
  )
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = var.enable_vpn_high_availability ? length(module.ingress_vpc.public_subnets) : 1
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = var.enable_vpn_high_availability ? element(module.ingress_vpc.public_subnets, count.index) : module.ingress_vpc.public_subnets[0]
}

resource "aws_ec2_client_vpn_authorization_rule" "all_groups" {
  count                  = var.environment == "non-production" ? length(local.allowed_cidr_ranges) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  target_network_cidr    = local.allowed_cidr_ranges[count.index]
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "workload_route" {
  count                  = var.enable_vpn_high_availability ? length(module.ingress_vpc.public_subnets) : 1
  description            = "Route to the workload network"
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  destination_cidr_block = "10.0.0.0/8"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.default[count.index].subnet_id
}


module "https_vpn_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "https-443-tcp"
  vpc_id = module.ingress_vpc.vpc_id

  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
}

module "kubernetes_vpn_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "kubernetes-api-tcp"
  vpc_id = module.ingress_vpc.vpc_id

  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["kubernetes-api-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["kubernetes-api-tcp"]
}

# Certificate server

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "${local.vpn_name}.vpn.server"
    organization = local.organization_name
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

# Certificate root

resource "tls_private_key" "root" {
  algorithm = "RSA"
}

resource "tls_cert_request" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = "${local.vpn_name}.vpn.client"
    organization = local.organization_name
  }
}

resource "tls_locally_signed_cert" "root" {
  cert_request_pem   = tls_cert_request.root.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "root" {
  private_key       = tls_private_key.root.private_key_pem
  certificate_body  = tls_locally_signed_cert.root.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

# Certificate CA

resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "${local.vpn_name}.vpn.ca"
    organization = local.organization_name
  }

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem
}
