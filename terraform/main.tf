terraform {
      # Версия terraform
      required_version = "0.11.13"
      }

provider "google" {
    # Версияпровайдера
    version = "2.0.0"
    # ID проекта
    project = "infra-234921"

    region = "europe-west3-a"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }

  metadata {
      # путьдопубличногоключа
      ssh-keys = "chudinanton:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    network = "default"

    access_config {}
  }
}