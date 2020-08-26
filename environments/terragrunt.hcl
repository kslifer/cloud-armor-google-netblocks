# terragrunt.hcl
remote_state {
  backend = "gcs"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "rpyell-taos-bucket"
    prefix  = "terraform/test/${path_relative_to_include()}"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  version   = "~> 3.24"
}
provider "google-beta" {
  version   = "~>  3.35"
}
EOF
}
