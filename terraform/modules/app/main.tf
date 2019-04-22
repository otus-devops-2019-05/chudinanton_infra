resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

data "template_file" "gen" {
  template = "${file("${path.module}/files/puma.service")}"

  vars = {
    mongodb_ip = "${var.mongodb_ip}"
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  count        = "${var.count}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  #connection {
  #    type  = "ssh"
  #    user  = "appuser"
  #    agent = false

  # путь до приватного ключа
  #    private_key = "${file(var.private_key_path)}"
  #  }

  #provisioner "file" {
  #  content     = "${data.template_file.gen.rendered}"
  #  destination = "/tmp/puma.service"
  #}

  #provisioner "remote-exec" {
  #  script = "${path.module}/files/deploy.sh"
  #}
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9293"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
