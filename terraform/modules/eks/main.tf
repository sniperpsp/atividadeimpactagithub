module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  iam_role_additional_policies = {
    AmazonSSManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonEBSCSIDriverPolicy : "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = ""
  subnet_ids = ["subnet-03b6ee804b2286286", "subnet-03b8d3bb451b4f803", "subnet-0fc87cdf8c4987551"]

  eks_managed_node_groups = {
    lab = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "hml"
    Project     = "lab-eks"
  }


}