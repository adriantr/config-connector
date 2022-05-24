resource "google_service_account" "foo" {
  account_id = "namespace-foo"
}

#Assign other IAM permissions if needed.
resource "google_project_iam_member" "foo" {
  for_each = toset(["roles/iam.serviceAccountAdmin", "roles/storage.admin"])
  project  = var.project_id
  member   = "serviceAccount:${google_service_account.foo.email}"
  role     = each.key
}

resource "google_service_account_iam_member" "foo" {
  service_account_id = google_service_account.foo.id
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  role               = "roles/iam.workloadIdentityUser"
}

