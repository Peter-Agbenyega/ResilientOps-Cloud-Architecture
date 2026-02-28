locals {
  project_tags = {
    contact      = "admin@nexuscloud360.com"
    application  = "networking"
    project      = "ResilientOps-Cloud-Architecture"
    environment  = terraform.workspace
    creationTime = timestamp()
  }
}