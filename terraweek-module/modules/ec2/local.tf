locals {
    project-name = var.env == "Prod" ? "prod-terra-week" : "dev-terra-week"


    common_tags = {
        Name = local.project-name
        Environment = var.env
    }
}