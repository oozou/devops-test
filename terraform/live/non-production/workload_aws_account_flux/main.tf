locals {
  environment = "non-production"
}

module "flux" {
  source = "../../../modules/flux"

  github_org                           = "johnnii-dev"
  github_repository                    = "devops-test"
  aws_secretsmanager_flux_github_token = "flux-github-token"
  deploy_key_name                      = "${local.environment}-flux-14-03-2024" # Please change the date whenever you update the GitHub token because the deploy key needs to be regenerated
  create_private_key                   = false                                  # Only enable this when you perform a test installation on your local environment
  aws_secretsmanager_flux_private_key  = "flux-private-key"
  aws_secretsmanager_flux_public_key   = "flux-public-key"
  cluster_name                         = "${local.environment}-eks-cluster"
  flux_path                            = "fluxcd/clusters/${local.environment}"
  github_branch                        = "main"
  flux_version                         = "v2.2.3" # Don't change this unless you plan to perform Flux upgrade
  flux_components_extra = [
    "image-reflector-controller",
    "image-automation-controller"
  ]
  kustomization_override = file("./kustomization.yaml")
  network_policy         = false
}
