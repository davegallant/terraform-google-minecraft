variable "google_cloud_project_id" {
  description = "The project ID and project number are displayed on the project Dashboard Project info card"
  type        = string
}

variable "region" {
  description = "The region for all applicable resources"
  type        = string
}

variable "zone" {
  description = "The availability zone for all applicable resources"
  type        = string
}

variable "machine_type" {
  description = "The machine type of the compute instance running Minecraft"
  type        = string
  default     = "n1-highcpu-2"
}

variable "seed" {
  description = "The minecraft seed to generate the world"
  type        = string
}

variable "minecraft_version" {
  description = "The tag/version of the minecraft docker image. https://hub.docker.com/r/itzg/minecraft-server/tags"
  type        = string
  default     = "1.12.0-multiarch"
}

variable "difficulty" {
  description = "The difficulty level of the server"
  type        = string
  default     = "easy"
}

variable "preemptible" {
  description = "Whether or not to use preemptible instances"
  type        = bool
  default     = true
}
