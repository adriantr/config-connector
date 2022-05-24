resource "random_string" "main" {
  length  = 5
  special = false
  upper   = false
}

resource "google_storage_bucket" "main" {
  name                        = "config-connector-${random_string.main.result}"
  uniform_bucket_level_access = true
  location                    = "europe-north1"
}

resource "google_storage_bucket_object" "main" {
  bucket  = google_storage_bucket.main.id
  name    = "thefile.txt"
  content = file("gs/thefile.txt")
}
