# The forwarding rule resource needs the self_link but the firewall rules only need the name.
# Using a data source here to access both self_link and name by looking up the network name.
data "google_compute_network" "network" {
  name    = "${var.network}"
  project = "${var.shared_vpc_enabled ? var.shared_vpc_project : var.project}"
}

data "google_compute_subnetwork" "network" {
  name    = "${var.subnetwork}"
  project = "${var.shared_vpc_enabled ? var.shared_vpc_project : var.project}"
}

resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "${var.lb_name}-fr"
  region                = "${var.region}"
  network               = "${data.google_compute_network.network.self_link}"
  subnetwork            = "${data.google_compute_subnetwork.network.self_link}"
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${google_compute_region_backend_service.default.self_link}"
  ip_address            = "${var.ip_address}"
  ip_protocol           = "${var.ip_protocol}"
  ports                 = ["${var.ports}"]
}

resource "google_compute_region_backend_service" "default" {
  project          = "${var.project}"
  name             = "${var.lb_name}-be"
  region           = "${var.region}"
  protocol         = "${var.ip_protocol}"
  timeout_sec      = 10
  session_affinity = "${var.session_affinity}"
  backend          = ["${var.backends}"]
  health_checks    = ["${element(compact(concat(google_compute_health_check.tcp.*.self_link,google_compute_health_check.http.*.self_link)), 0)}"]
}

resource "google_compute_health_check" "tcp" {
  count = "${var.http_health_check ? 0 : 1}"
  project = "${var.project}"
  name    = "${var.lb_name}-hc-tcp"

  tcp_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_health_check" "http" {
  count = "${var.http_health_check ? 1 : 0}"
  project = "${var.project}"
  name    = "${var.lb_name}-hc-http"

  http_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_firewall" "default-fw" {
  project = "${var.shared_vpc_enabled ? var.shared_vpc_project : var.project}"
  name    = "${var.lb_name}-fw"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "${lower(var.ip_protocol)}"
    ports    = ["${var.ports}"]
  }

  source_tags = ["${var.source_tags}"]
  target_tags = ["${var.target_tags}"]
}

resource "google_compute_firewall" "default-hc-fw" {
  project = "${var.shared_vpc_enabled ? var.shared_vpc_project : var.project}"
  name    = "${var.lb_name}-gcp-hc-fw"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["${var.health_port}"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["${var.target_tags}"]
}
