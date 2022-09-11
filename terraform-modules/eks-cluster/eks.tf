module "eks" {
  depends_on = [null_resource.prequisites_check]
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.22"
  subnets         = module.vpc.private_subnets
  
  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    ng-01 = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 2

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

map_users = [
    {
      userarn  = local.current_user_arn
      username = local.current_user_name
      groups   = ["system:masters"]
    },
  ]
}