# $environment/$region/$module/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/cloud_armor"

    extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=${get_terragrunt_dir()}/../../organization.tfvars",
      "-var-file=${get_terragrunt_dir()}/../environment.tfvars",
    ]
  }
}

inputs = {
    
}
