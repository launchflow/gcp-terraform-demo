
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "gcp-terraform-demo-project"
  region  = "us-central1"
}

# Application assets storage bucket
resource "google_storage_bucket" "assets_bucket" {
  name     = "gcp-demo-assets-bucket-${random_id.bucket_suffix.hex}"
  location = "US"
  
  uniform_bucket_level_access = false
  
  versioning {
    enabled = true
  }
}

# Bucket access configuration for application assets
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.assets_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Service account for application workloads
resource "google_service_account" "app_service_account" {
  account_id   = "demo-app-service-account"
  display_name = "Demo Application Service Account"
  description  = "Service account for demo application workloads"
}

# IAM permissions for the application service account
resource "google_project_iam_member" "app_permissions" {
  project = "gcp-terraform-demo-project"
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

# Main application service running on Cloud Run
resource "google_cloud_run_v2_service" "demo_app" {
  name     = "demo-application"
  location = "us-central1"

  template {
    service_account = google_service_account.app_service_account.email
    
    containers {
      image = "gcr.io/cloudrun/hello"
      
      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.assets_bucket.name
      }
      
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}

# Public access configuration for the Cloud Run service
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.demo_app.name
  location = google_cloud_run_v2_service.demo_app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Random suffix for unique resource naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# PostgreSQL database for application data
resource "google_sql_database_instance" "demo_db" {
  name             = "demo-database-${random_id.db_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = "us-central1"
  
  settings {
    tier = "db-f1-micro"
    
    backup_configuration {
      enabled = true
    }
    
    ip_configuration {
      ipv4_enabled = true
    }
  }
  
  deletion_protection = false
}

# Random suffix for database naming
resource "random_id" "db_suffix" {
  byte_length = 4
}

# Application server for additional workloads
resource "google_compute_instance" "app_server" {
  name         = "demo-app-server"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP for external access
    }
  }

  # Resource labels for organization and billing
  labels = {
    environment = "dev"
    purpose     = "demo"
  }

  service_account {
    email  = google_service_account.app_service_account.email
    scopes = ["cloud-platform"]
  }

  # Startup script to configure the server
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Demo App Server - Environment: dev</h1>" > /var/www/html/index.html
    echo "<p>Server configured via Terraform</p>" >> /var/www/html/index.html
  EOF

  tags = ["http-server", "https-server"]
}

# Firewall rule to allow HTTP/HTTPS traffic to the app server
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-demo"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}
