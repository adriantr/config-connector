data "google_client_config" "main" {}

resource "google_project_service" "services" {
  for_each = toset(["compute.googleapis.com", "container.googleapis.com"])

  project = var.project_id
  service = each.key
}
