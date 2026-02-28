locals {
  project_tags = {
    contact      = "admin@nexuscloud360.com"
    application  = "networking"
    project      = "terraform-enterprise-lab"
    environment  = "${terraform.workspace}" # dev, prod, etc
    creationTime = timestamp()
  }
}