# ==============================================================================
# EKS Module - Terraform AWS Modules v21.0
# Configuração hardcoded para QuickOrder
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Cluster Configuration
  name               = "quickorder-prod-eks-1"
  kubernetes_version = "1.34"

  # Addons
  addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      before_compute = true
      most_recent    = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent    = true
    }
  }

  # Acesso público ao endpoint
  endpoint_public_access = true

  # Permissões de admin para o criador do cluster
  enable_cluster_creator_admin_permissions = true

  # Configuração de rede (você vai precisar pegar da sua VPC)
  vpc_id     = "vpc-08df91bf076ee540c"
  subnet_ids = ["subnet-0857404631b84a6bd", "subnet-0528d6ee40d8afe64"]

  # EKS Managed Node Group
  eks_managed_node_groups = {
    quickorder_nodes = {
      # AL2023 é o padrão a partir do Kubernetes 1.30
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"  # Economia de até 90%

      min_size     = 2
      max_size     = 4
      desired_size = 2

      # Políticas IAM adicionais
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      # Labels para identificação
      labels = {
        Environment = "prod"
        Project     = "quickorder"
        NodeGroup   = "quickorder-nodes"
      }
    }
  }

  # Tags
  tags = {
    Terraform   = "true"
    Environment = "prod"
    Project     = "quickorder"
  }
}