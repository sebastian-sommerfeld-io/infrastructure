resource "digitalocean_app" "docs-page" {
  spec {
    domains = [
      "${digitalocean_record.CNAME-docs.name}.${digitalocean_domain.cloud.name}",
    ]
    name   = "docs-page"
    region = var.do_region

    service {
      name               = "docs-page-app"
      http_port          = 80
      instance_count     = 1
      instance_size_slug = var.do_instance_smallest
      internal_ports     = []
      source_dir         = "/"

      image {
        registry_type = "DOCKER_HUB"
        registry      = "sommerfeldio"
        repository    = "docs-website"
        tag           = "stable"
      }

      routes {
        path                 = "/"
        preserve_path_prefix = false
      }
    }
  }
}

resource "digitalocean_domain" "cloud" {
  name = var.do_base_domain
}

resource "digitalocean_record" "CNAME-docs" {
  domain = digitalocean_domain.cloud.name
  type   = "CNAME"
  name   = "docs"
  value  = "@"
}
