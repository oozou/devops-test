provider "github" {
  owner = var.github_org
  token = data.aws_secretsmanager_secret_version.flux_github_token.secret_string
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = var.cluster_name
}

data "aws_secretsmanager_secret" "flux_public_key" {
  count = var.create_private_key == false ? 1 : 0

  name = var.aws_secretsmanager_flux_public_key
}

data "aws_secretsmanager_secret_version" "flux_public_key" {
  count = var.create_private_key == false ? 1 : 0

  secret_id = data.aws_secretsmanager_secret.flux_public_key[0].id
}

data "aws_secretsmanager_secret" "flux_private_key" {
  count = var.create_private_key == false ? 1 : 0

  name = var.aws_secretsmanager_flux_private_key
}

data "aws_secretsmanager_secret_version" "flux_private_key" {
  count = var.create_private_key == false ? 1 : 0

  secret_id = data.aws_secretsmanager_secret.flux_private_key[0].id
}

data "aws_secretsmanager_secret" "flux_github_token" {
  name = var.aws_secretsmanager_flux_github_token
}

data "aws_secretsmanager_secret_version" "flux_github_token" {
  secret_id = data.aws_secretsmanager_secret.flux_github_token.id
}

resource "tls_private_key" "flux" {
  count     = var.create_private_key == true ? 1 : 0
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "flux" {
  title      = var.deploy_key_name
  repository = var.github_repository
  key        = var.create_private_key == true ? tls_private_key.flux[0].public_key_openssh : data.aws_secretsmanager_secret_version.flux_public_key[0].secret_string
  read_only  = "false"
}

provider "flux" {
  # kubernetes = var.flux_kubernetes # TODO: pass kubernetes context from the caller side
  kubernetes = {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster.token

    # # For locally testing purpose
    # config_path = "~/.kube/config"
    # config_context = "docker-desktop"
  }

  git = {
    url    = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    branch = var.github_branch
    ssh = {
      username    = "git"
      private_key = var.create_private_key == true ? tls_private_key.flux[0].private_key_pem : data.aws_secretsmanager_secret_version.flux_private_key[0].secret_string
    }
  }
}

resource "flux_bootstrap_git" "flux" {
  depends_on = [github_repository_deploy_key.flux]

  path                   = var.flux_path
  version                = var.flux_version
  components_extra       = var.flux_components_extra
  kustomization_override = var.kustomization_override
  network_policy         = var.network_policy
}
