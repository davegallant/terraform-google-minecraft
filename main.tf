terraform {
  backend "gcs" {
    prefix = "minecraft"
  }
}

data "terraform_remote_state" "state" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
  }
}

locals {
  project = var.google_cloud_project_id
  region  = var.region
  zone    = var.zone
}

provider "google" {
  project = local.project
  region  = local.region
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

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_resource_policy" "backup_policy" {
  name   = "minecraft-backup-policy"
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
    retention_policy {
      max_retention_days    = var.snapshot_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = ["us"]
    }
  }

}

resource "google_compute_disk_resource_policy_attachment" "backup_policy_attachment" {
  name = google_compute_resource_policy.backup_policy.name
  disk = google_compute_disk.minecraft.name
  zone = var.zone
}

# Static IP address
resource "google_compute_address" "minecraft" {
  name   = "minecraft-ip"
  region = local.region
}

resource "google_compute_instance_group_manager" "minecraft" {
  name               = "minecraft"
  base_instance_name = "minecraft"
  target_size        = 1
  zone               = local.zone

  version {
    instance_template = google_compute_instance_template.minecraft.self_link
  }
}

# Template that runs minecraft from a docker container on a compute instance
resource "google_compute_instance_template" "minecraft" {
  name_prefix  = "minecraft-template-"
  machine_type = var.machine_type
  tags         = ["minecraft"]

  lifecycle {
    create_before_destroy = true
  }

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
    itzg/minecraft-server:${var.minecraft_version};
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
