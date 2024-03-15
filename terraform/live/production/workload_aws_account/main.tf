locals {
  environment            = "production"
  vpc_cidr               = "10.4.0.0/16"
  vpc_cidr_ingress       = "192.168.128.0/21"
  vpc_cidr_deployment    = "10.129.2.0/23"
  azs                    = 3
  transit_gateway        = "tgw-09dd5ff3f4b321f22"
  cluster_name           = "${local.environment}-eks-cluster"
  master_cluster_version = "1.29"
  worker_cluster_version = "1.29" # separated from master version so upgrading master doesn't cause upgrading workers immediately
}

module "vpc" {
  source = "../../../modules/vpc_workload"

  environment                                     = local.environment
  vpc_cidr                                        = local.vpc_cidr
  azs_number                                      = local.azs
  cluster_name                                    = local.cluster_name
  enable_flow_log                                 = true
  flow_log_max_aggregation_interval               = 600
  flow_log_cloudwatch_log_group_retention_in_days = 3
  flow_log_traffic_type                           = "REJECT"
  flow_log_cloudwatch_log_group_name_suffix       = "reject"
}

module "transit_gateway_vpc_attachment" {
  source = "../../../modules/transit_gateway/vpc_attachment"

  destination_cidr_blocks = ["0.0.0.0/0"]
  route_table_ids         = concat(module.vpc.public_route_table_ids, module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids)
  subnet_ids              = module.vpc.intra_subnets
  transit_gateway_id      = local.transit_gateway
  vpc_id                  = module.vpc.vpc_id
}

module "eks" {
  source = "../../../modules/eks"

  environment              = local.environment
  cluster_name             = local.cluster_name
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  cluster_version          = local.master_cluster_version
  control_plane_ingress_cidr_blocks = [
    local.vpc_cidr_ingress,
    local.vpc_cidr_deployment,
  ]
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types = [
      "t3.small",
      "t3a.small",
    ]
    capacity_type   = "SPOT"
    cluster_version = local.worker_cluster_version
    create_iam_role = false
    iam_role_arn    = module.eks_worker_node_iam_role.arn
  }
  eks_managed_node_groups = {
    apps-pool = {
      use_custom_launch_template = false
      min_size                   = 1
      max_size                   = 3
      desired_size               = 2

      disk_size = 20
      taints = {
        cilium = { # required by Cilium
          key    = "node.cilium.io/agent-not-ready"
          value  = "true"
          effect = "NO_EXECUTE"
        }
      }
      labels = {
        node-pool = "app-node-pool"
      }
    }
    infra-pool = {
      use_custom_launch_template = false
      min_size                   = 1
      max_size                   = 3
      desired_size               = 2
      capacity_type              = "ON_DEMAND"
      instance_types = [
        "t3.medium",
        "t3a.medium"
      ]
      disk_size = 20
      taints = {
        cilium = { # required by Cilium
          key    = "node.cilium.io/agent-not-ready"
          value  = "true"
          effect = "NO_EXECUTE"
        }
      }
      labels = {
        node-group = "infra-node-pool"
      }
    }
  }
}
