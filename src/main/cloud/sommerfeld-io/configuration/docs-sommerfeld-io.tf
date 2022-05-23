# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/app
resource "digitalocean_app" "docs_page" {
  spec {
    name   = "docs_page"
    region = "fra1"

    # domain

    service {
      name      = "docs_page_image"
      http_port = 3000

      image {
        registry_type = "DOCKER_HUB"
        repository    = "sommerfeldio/docs-website"
        tag           = "stable"
      }
    }
  }
}
