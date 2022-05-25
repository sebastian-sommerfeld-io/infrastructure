terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    linode = {
      source  = "linode/linode"
      version = "1.27.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "linode" {
  token = var.linode_token
}

data "linode_account" "account" {}
