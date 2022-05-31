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

data "digitalocean_account" "do_account" {}

provider "linode" {
  token = var.linode_token
}

data "linode_account" "linode_account" {}
