terraform {
  backend "gcs" {
    prefix = "minecraft"
  }
}

locals {
  project = var.google_cloud_project_id
  region  = var.region
  zone    = var.zone
}

provider "google" {
  version = "~> 3.21"
  project = local.project
  region  = local.region
}

resource "random_id" "minecraft" {
  byte_length = 8
}

resource "google_service_account" "minecraft" {
  account_id   = "minecraft"
  display_name = "minecraft"
}

# Persistent disk
resource "google_compute_disk" "minecraft" {
  name  = "minecraft"
  type  = "pd-standard"
  zone  = local.zone
  image = "cos-cloud/cos-stable"
}

# Static IP address
resource "google_compute_address" "minecraft" {
  name   = "minecraft-ip"
  region = local.region
}

resource "google_compute_instance_group_manager" "minecraft" {
  name               = "minecraft-${random_id.minecraft.hex}"
  base_instance_name = "minecraft"
  target_size        = 1
  zone               = local.zone

  version {
    instance_template = google_compute_instance_template.minecraft.self_link
  }
}

# Template that runs minecraft from a docker container
resource "google_compute_instance_template" "minecraft" {
  name         = "minecraft-template-${random_id.minecraft.hex}"
  machine_type = var.machine_type
  tags         = ["minecraft"]

  metadata_startup_script = <<-EOT

  docker run -d \
    --name=minecraft \
    --restart=always \
    -p 25565:25565 \
    -e DIFFICULTY=${var.difficulty} \
    -e ENABLE_RCON=true \
    -e EULA=TRUE \
    -e SEED=${var.seed} \
    -v /var/minecraft:/data \
    itzg/minecraft-server:latest;
  EOT

  disk {
    auto_delete = false # Keep disk after shutdown
    source      = google_compute_disk.minecraft.name
  }

  network_interface {
    network = google_compute_network.minecraft.name
    access_config {
      nat_ip = google_compute_address.minecraft.address
    }
  }

  service_account {
    email  = google_service_account.minecraft.email
    scopes = ["userinfo-email"]
  }

  scheduling {
    preemptible       = var.preemptible
    automatic_restart = false
  }
}

resource "google_compute_network" "minecraft" {
  name = "minecraft"
}

resource "google_compute_firewall" "minecraft" {
  name    = "minecraft"
  network = google_compute_network.minecraft.name
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft"]
}

