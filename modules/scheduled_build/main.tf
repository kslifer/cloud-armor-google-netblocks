# Project number
data "google_project" "project" {
  project_id = var.project
}

# APIs
resource "google_project_service" "cloudbuild_api" {
  project = var.project
  service = "cloudbuild.googleapis.com"
}
resource "google_project_service" "cloudscheduler_api" {
  project = var.project
  service = "cloudscheduler.googleapis.com"
}

# Ensure Cloud Build account has permissions
resource "google_project_iam_member" "project" {
  project = var.project
  role   = "roles/editor"
  member = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild_api]
}

# Setup Cloud Build trigger
resource "google_cloudbuild_trigger" "github" {
  provider = google-beta
  project = var.project

  name = "cloud-armor-http-tf-job-trigger"
  description = "Cloud Armor HTTP Terraform job trigger"
  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "master"
    }
  }
  filename = "cloudbuild.yaml"

  depends_on = [google_project_service.cloudbuild_api]
}

# Setup Cloud Scheduler to hit the trigger
resource "google_cloud_scheduler_job" "job" {
  project = var.project
  region = var.region

  name             = "cloud-armor-http-tf-job"
  description      = "Cloud Armor HTTP Terraform job"
  schedule         = var.schedule_cron
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.project}/triggers/${google_cloudbuild_trigger.github.trigger_id}:run"
    body        = base64encode("{\"branchName\":\"master\"}")

    oauth_token {
      service_account_email = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
    }
  }

  depends_on = [google_project_service.cloudscheduler_api]
}
