resource "aws_eip" "nlb" {
  count  = length(module.vpc.public_subnets) # match however many AZs your NLB spans
  domain = "vpc"
  tags   = { Name = "bankapp-nlb-eip-${count.index}" }
}

output "nlb_eip_allocation_ids" {
  value = join(",", aws_eip.nlb[*].id)
}
