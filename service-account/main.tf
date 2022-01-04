resource "google_project" "my_project" {
  name       = "my-second-project"
  project_id = "myproject-098765"
  billing_account = data.google_billing_account.acct.id
 

}
// available in data source section in cloud billing to enable billing to project
data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}
//cloud platform resource section for service account creation
resource "google_service_account" "service_account" {
  account_id   = "test-sa"
  display_name = "test account that avatalavpr@gmail.com can use"
  project      =  google_project.my_project.project_id

}
//bind the member or a principle to use a service account

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "user:avatalavpr@gmail.com",
  ]
}


// for key rotation
resource "time_rotating" "mykey_rotation" {
  rotation_days = 30
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.service_account.name

  keepers = {
    rotation_time = time_rotating.mykey_rotation.rotation_rfc3339
  }
  public_key_type = "TYPE_X509_PEM_FILE"
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
}
// iam custom role creation

resource "google_project_iam_custom_role" "my-custom-role" {
  role_id     = "myCustomRole"
  title       = "My Custom Role"
  description = "it is a custom role for iam"
  permissions = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
  project = google_project.my_project.project_id
}
//to enable the service in a project
resource "google_project_service" "project" {
  project = google_project.my_project.project_id
  service = "container.googleapis.com"



  disable_dependent_services = true
}

//create a service account and bind a role to it:

resource "google_service_account" "compute_storage_sa" {
  account_id   = "object-reader"
  display_name = "Multiple roles to a service accunt"
  project      =  google_project.my_project.project_id
  

}


resource "google_project_iam_member" "cloud_storage_reader" {
  project = google_project.my_project.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.compute_storage_sa.email}"
}

//binding multiple roles to a service account

data "google_iam_policy" "auth1" {
  binding {
    role = "roles/cloudsql.admin"
    members = [
      "serviceAccount:${google_service_account.compute_storage_sa.email}",
    ]
  }
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${google_service_account.compute_storage_sa.email}",
    ]
  }
  binding {
    role = "roles/datastore.owner"
    members = [
      "serviceAccount:${google_service_account.compute_storage_sa.email}",
    ]
  }
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.compute_storage_sa.email}",
    ]
  }
}

