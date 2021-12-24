provider "google" {
  region = var.region

}
terraform {
  backend "gcs" {
    credentials = "terraform-sakey.json"
    bucket      = "terraform-bucket-a"
    prefix      = "folder1"



  }
}
resource "google_compute_network" "vpc_network" {
  name                    = var.network
  auto_create_subnetworks = false


}
resource "google_compute_subnetwork" "vpc_subnet" {
  name                     = var.network
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.vpc_network.self_link
  region                   = var.region
  private_ip_google_access = true



}
data "google_client_config" "current" {

}
data "google_container_engine_versions" "default" {
  location = var.zone
}

resource "google_container_cluster" "default" {
  name               = var.network
  location           = var.zone
  initial_node_count = 3
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  network            = google_compute_network.vpc_network.self_link
  subnetwork         = google_compute_subnetwork.vpc_subnet.name
  enable_legacy_abac = true
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }



}

