resource "google_service_account" "cluster" {
  account_id = "cluster"
}

#Minimal IAM for cluster service account
resource "google_project_iam_member" "cluster" {
  for_each = toset(["roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cluster.email}"
}

resource "google_container_cluster" "main" {
  provider = google-beta

  name     = "config-connector"
  location = "europe-north1-a"

  initial_node_count = 1
  network            = google_compute_network.main.id
  subnetwork         = google_compute_subnetwork.main.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  node_config {
    disk_size_gb    = 20
    machine_type    = "e2-standard-4"
    preemptible     = true
    service_account = google_service_account.cluster.email
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "30.255.0.0/28"

    master_global_access_config {
      enabled = true
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    config_connector_config {
      enabled = true
    }
  }

  depends_on = [
    google_project_service.services
  ]
}

resource "kubernetes_manifest" "connector_config" {
  manifest = yamldecode(templatefile("manifests/connector.tftpl",
    {
      sa = google_service_account.foo.email
    }
  ))

  depends_on = [
    google_container_cluster.main
  ]
}
