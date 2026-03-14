# -------------------------------------------------------
# LOCALS
# -------------------------------------------------------

locals {

  # Base tags applied consistently across the reference architecture.
  project_tags = {
    contact     = "admin@nexuscloud360.com"
    owner       = "peter"
    application = "networking"
    project     = "terraform-enterprise-lab"
    environment = terraform.workspace
  }

  # Preserve the existing tag namespace to avoid unnecessary naming churn.
  merged_tags = merge(local.project_tags, var.extra_tags)
}
