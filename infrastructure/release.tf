resource "helm_release" "release" {
  chart            = "../app-chart"
  name             = "file-reader"
  namespace        = "file-reader"
  create_namespace = true
  values = [
    templatefile("../app-chart/values.yaml", {
      project_id  = var.project_id
      bucket_name = google_storage_bucket.main.name
    })
  ]
}
