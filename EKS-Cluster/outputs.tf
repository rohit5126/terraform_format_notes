output "cluster-endpoint" {
    value = module.eks.cluster_endpoint
  
}

output "cluster_name" {
    value = module.eks.cluster_name
}

output "cluster_security_group_id" {
    value = module.eks.cluster_security_group_id
  
}

output "configure_kubectl" {
  description = "Point kubectl at the new cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "argocd_initial_password" {
  description = "Read ArgoCD's generated admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

