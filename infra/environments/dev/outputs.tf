
output "bucket_name" {
  description = "Name of the created storage bucket"
  value       = google_storage_bucket.data_bucket.name
}

output "bucket_url" {
  description = "URL of the storage bucket"
  value       = google_storage_bucket.data_bucket.url
}

output "cloud_run_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.demo_app.uri
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.app_service_account.email
}

output "database_connection_name" {
  description = "Connection name for the SQL database"
  value       = google_sql_database_instance.postgres_db.connection_name
}

output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.k8s_cluster.name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.k8s_cluster.endpoint
  sensitive   = true
}

output "app_server_name" {
  description = "Name of the compute instance"
  value       = google_compute_instance.app_server.name
}

output "app_server_external_ip" {
  description = "External IP address of the compute instance"
  value       = google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip
}

output "app_server_internal_ip" {
  description = "Internal IP address of the compute instance"
  value       = google_compute_instance.app_server.network_interface[0].network_ip
}

output "app_server_zone" {
  description = "Zone where the compute instance is deployed"
  value       = google_compute_instance.app_server.zone
}
