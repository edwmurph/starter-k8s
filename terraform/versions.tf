terraform {
  required_version = "0.13.1"

  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = # name of bucket created for tfstate
    key                         = "terraform/terraform.tfstate"
  }

  required_providers {
    # https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}
