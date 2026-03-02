# -------------------------------------------------------
# LOCALS
# -------------------------------------------------------

locals {

  # Base project tags (class convention style)
  project_tags = {
    contact     = "admin@nexuscloud360.com"
    owner       = "peter"
    application = "networking"
    project     = "terraform-enterprise-lab"
    environment = terraform.workspace
  }

  # Merge base tags with optional extra tags
  merged_tags = merge(local.project_tags, var.extra_tags)
}