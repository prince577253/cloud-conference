terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "local" {
  # Local provider is used for this demo to avoid requiring real cloud credentials
}
