resource "google_container_registry" "main" {
  project  = var.project_id
  location = "EU"
}

resource "google_storage_bucket_iam_member" "gcr_allusers" {
  bucket = google_container_registry.main.bucket_self_link
  member = "allUsers"
  role   = "roles/storage.objectViewer"
}
