resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "appuser1:${file(var.public_key_path_appuser1)}\nappuser2:${file(var.public_key_path_appuser2)}\nappuser3:${file(var.public_key_path_appuser3)}"
  }
}
