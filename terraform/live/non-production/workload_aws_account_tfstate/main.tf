locals {
  environment   = "non-production"
  random_suffix = "zxcvbn"
}

module "tfstate" {
  source = "../../../modules/tfstate_backend"

  environment   = local.environment
  random_suffix = local.random_suffix

}
