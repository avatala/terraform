output "network" {
  value = google_compute_network.vpc_network.name

}
output "subnetwork" {
  value = google_compute_subnetwork.vpc_subnet.name

}
output "cluster_name" {
  value = google_container_cluster.default.name

}
output "region" {

  value = var.region

}
output "location" {
  value = google_container_cluster.default.location
}

output "token-op" {
  value = data.google_client_config.current.access_token
  sensitive = true
}

output "client_certificate-op" {

  value = google_container_cluster.default.master_auth[0].client_certificate

}
output "client-key-op" {
  value = google_container_cluster.default.master_auth[0].client_key
  sensitive = true

}
output "client-ca-cert" {
  value = google_container_cluster.default.master_auth[0].cluster_ca_certificate
}

output "ns" {
  value = kubernetes_namespace.staging.metadata[0].name

}
output "host-value" {
  value =google_container_cluster.default.endpoint
}