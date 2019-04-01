resource "google_compute_http_health_check" "reddit_app_healthcheck" {
  name = "reddit-healthcheck"
  port = "9292"
  request_path       = "/"
  timeout_sec = 1
  check_interval_sec = 1
}

resource "google_compute_target_pool" "reddit_app_pool" {
  name = "reddit-app"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.reddit_app_healthcheck.name}",
  ]
}

resource "google_compute_forwarding_rule" "reddit_forwarding_rule" {
  name = "reddit-forwarding-rule"
  target = "${google_compute_target_pool.reddit_app_pool.self_link}"
  port_range = "9292"
}
