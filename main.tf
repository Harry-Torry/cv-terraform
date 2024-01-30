terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_app" "cv-app" {
  spec {
    name   = "cv-static-site"
    region = "lon"

    domain {
      name = "cv.h3y.dev"
    }

    static_site {
      name       = "static"
      output_dir = "/"

      github {
        repo           = "Harry-Torry/cv2"
        branch         = "main"
        deploy_on_push = true
      }
    }
  }
}

resource "digitalocean_domain" "h3y-dev" {
  name = "h3y.dev"
}

resource "digitalocean_record" "cv_cname" {
  domain = digitalocean_domain.h3y-dev.name
  type   = "CNAME"
  name   = "cv"
  value  = format("%s.", replace(digitalocean_app.cv-app.default_ingress, "https://", ""))
}
