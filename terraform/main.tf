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
