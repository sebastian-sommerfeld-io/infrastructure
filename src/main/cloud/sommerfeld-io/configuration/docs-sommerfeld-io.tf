# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/app
resource "digitalocean_app" "docs-page-docker-app" {
  spec {
    name   = "docs-page-docker-app"
    region = "fra1"

    # domain

    service {
      name      = "docs-page-docker-app-image"
      http_port = 3000

      image {
        registry_type = "DOCKER_HUB"
        repository    = "sommerfeldio/docs-website"
        tag           = "stable"
      }
    }
  }
}
