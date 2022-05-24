terraform {
  backend "gcs" {
    bucket = "kubectl-blogposts"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.main.endpoint}"
  token                  = data.google_client_config.main.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.main.master_auth.0.cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
    host                   = google_container_cluster.main.endpoint
    token                  = data.google_client_config.main.access_token
    client_certificate     = base64decode(google_container_cluster.main.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.main.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.main.master_auth.0.cluster_ca_certificate)
  }
}
