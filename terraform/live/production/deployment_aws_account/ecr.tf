locals {
  non_production_workload_allow_iam_roles = [
    "arn:aws:iam::471112530874:role/flux-role",
    "arn:aws:iam::471112530874:role/eks-worker-node-role",
  ]
  production_workload_allow_iam_roles = [
    "arn:aws:iam::590183883768:role/flux-role",
    "arn:aws:iam::590183883768:role/eks-worker-node-role",
  ]

  repositories = [
    # Container images
    {
      name = "dockers/hardened-node-application"
      repository_read_access_arns = flatten([
        local.non_production_workload_allow_iam_roles,
        local.production_workload_allow_iam_roles
      ])
      repository_lifecycle_policy = jsonencode({
        rules = [
          {
            rulePriority = 1,
            description  = "Keep last 30 images",
            selection = {
              tagStatus   = "any",
              countType   = "imageCountMoreThan",
              countNumber = 30
            },
            action = {
              type = "expire",
            },
          }
        ]
      })
    },
    # Helm Chart
    {
      name = "charts/app"
      repository_read_access_arns = flatten([
        local.non_production_workload_allow_iam_roles,
        local.production_workload_allow_iam_roles
      ])
    },
  ]
}

module "ecr" {
  for_each = {
    for repository in local.repositories : repository.name => repository
  }
  source = "../../../modules/ecr"

  repository_name                   = each.value.name
  repository_lifecycle_policy       = try(each.value.repository_lifecycle_policy, "")
  repository_read_write_access_arns = lookup(each.value, "repository_read_write_access_arns", [])
  repository_read_access_arns       = lookup(each.value, "repository_read_access_arns", [])
  repository_image_tag_mutability   = lookup(each.value, "repository_image_tag_mutability", "IMMUTABLE")
  repository_type                   = try(each.value.repository_type, "private")
}
