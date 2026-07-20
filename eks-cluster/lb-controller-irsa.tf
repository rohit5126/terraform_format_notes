resource "aws_iam_policy" "aws_lb_controller" {
  name   = "${var.cluster-name}-AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/iam_policy.json")
}

module "irsa_lb_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster-name}-lb-controller-irsa"

  role_policy_arns = {
    policy = aws_iam_policy.aws_lb_controller.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

output "lb_controller_role_arn" {
  value = module.irsa_lb_controller.iam_role_arn
}