locals {
  environment   = "production"
  random_suffix = "kkkkgm"
}

module "tfstate" {
  source = "../../../modules/tfstate_backend"

  environment   = local.environment
  random_suffix = local.random_suffix
}
