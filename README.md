# Config Connector

This repo deploys a demo of config connector utilizing Terraform and Helm. It's based on cluster-scoped connector and exposes a rest API endpoint that fetches the content of a Cloud Storage-saved object.

## Installation

```
export TF_VAR_project_id=<YOUR_PROJECT_ID>
terraform apply --target google_container_cluster.main --auto-approve
terraform apply --auto-approve
```
