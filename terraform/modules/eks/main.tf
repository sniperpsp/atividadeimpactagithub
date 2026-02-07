# ==============================================================================
# EKS Module - Usando módulo oficial terraform-aws-modules/eks
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-${var.environment}-eks"
  cluster_version = var.cluster_version

  # Acesso público ao endpoint (pode ser desabilitado em produção)
  cluster_endpoint_public_access = true

  # Permissões de admin para o criador do cluster
  enable_cluster_creator_admin_permissions = true

  # Políticas IAM adicionais para nodes
  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  # Addons do EKS (CoreDNS, kube-proxy, VPC CNI)
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

  # Configuração de rede
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Node Groups gerenciados
  eks_managed_node_groups = {
    quickorder_nodes = {
      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      instance_types = [var.node_instance_type]
      capacity_type  = "SPOT"  # Economia de até 90%

      # Configurações de atualização
      update_config = {
        max_unavailable_percentage = 33
      }

      # Labels para identificação
      labels = {
        Environment = var.environment
        Project     = var.project_name
      }

      # Taints (opcional)
      # taints = []
    }
  }

  # Tags
  tags = var.tags
}
