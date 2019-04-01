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
  tags = ["reddit-app"]

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

  connection {
    type  = "ssh"
    user  = "chudinanton"
    agent = false

    # путь до приватного ключа
    private_key = "${file("~/.ssh/id_rsa.pub")}"
}

 provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
 }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
 }

}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
