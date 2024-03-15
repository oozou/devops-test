module "eks_worker_node_iam_role" {
  source = "../../../modules/iam/role"

  name = "eks-worker-node-role"
  assume_role_policy = {
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  }
  attached_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

module "flux_iam_role" {
  source = "../../../modules/iam/role"

  name = "flux-role"
  assume_role_policy = {
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition : {
          StringEquals : {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" : [
              "system:serviceaccount:flux-system:source-controller",
              "system:serviceaccount:flux-system:image-reflector-controller"
            ]
          }
        }
      }
    ]
    Version = "2012-10-17"
  }
  attached_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
