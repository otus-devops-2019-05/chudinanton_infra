output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

#output "balancer_ip" {
#  value = "${google_compute_forwarding_rule.reddit_forwarding_rule.ip_address}"
#}

