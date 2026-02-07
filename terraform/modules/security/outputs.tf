output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2.id
}

output "eks_cluster_security_group_id" {
  value = aws_security_group.eks_cluster.id
}

output "eks_node_security_group_id" {
  value = aws_security_group.eks_node.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis.id
}

