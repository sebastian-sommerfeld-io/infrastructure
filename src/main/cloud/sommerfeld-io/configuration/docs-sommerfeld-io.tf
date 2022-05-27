resource "digitalocean_app" "docs-page" {
  spec {
    domain {
      name = "docs.${var.do_base_domain}"
    }
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

data "digitalocean_app" "docs-page-data" {
  app_id = digitalocean_app.docs-page.id
}

#resource "digitalocean_domain" "cloud" {
#  name = var.do_base_domain
#}
#
#resource "digitalocean_record" "CNAME-docs" {
#  domain = digitalocean_domain.cloud.name
#  type   = "CNAME"
#  name   = "docs"
#  value  = "@"
#}
