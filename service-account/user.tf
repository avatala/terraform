
//cloud platform resource google_project_iam  principle or member creation

resource "google_project_iam_member" "project" {
  project = google_project.my_project.project_id
  role    = "roles/firebase.admin"
  member  = "user:avatalavpr@gmail.com"

  condition {
    title       = "expires_after_2023_12_31"
    description = "Expiring at midnight of 2023-12-31"
    expression  = "request.time < timestamp(\"2023-01-01T00:00:00Z\")"
  }
}
// binding a role to the member or principle
resource "google_project_iam_binding" "project" {
  project = google_project.my_project.project_id
  role    = "roles/container.admin"

  members = [
    "user:avatalavpr@gmail.com",
  ]

  condition {
    title       = "expires_after_2023_12_31"
    description = "Expiring at midnight of 2023-12-31"
    expression  = "request.time < timestamp(\"2023-01-01T00:00:00Z\")"
  }
}


data "google_project" "project" {
}

output "project_number" {
  value = data.google_project.project.number
}

