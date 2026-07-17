locals {
  env = {
    Prod ={
        instance-count = "2"
    }
    dev = {
        instance-count = "1"
    }
    
  }
  current = lookup(local.env, terraform.workspace, local.env["dev"])
}

module "ec2" {
    source = "./modules/ec2"
    env = terraform.workspace
    instance-count = local.current.instance-count
    
    
}