resource "google_compute_network" "main" {
  name                    = "cluster-network"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.services
  ]
}

resource "google_compute_subnetwork" "main" {
  network                  = google_compute_network.main.id
  ip_cidr_range            = "30.0.0.0/14"
  name                     = "cluster-subnetwork"
  region                   = "europe-north1"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.31.0.0/20"
  }
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.32.0.0/16"
  }
}
