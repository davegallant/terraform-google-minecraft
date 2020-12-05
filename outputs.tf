output network_ip {
  value = google_compute_instance_template.minecraft.network_interface.0.access_config.0.nat_ip
}
