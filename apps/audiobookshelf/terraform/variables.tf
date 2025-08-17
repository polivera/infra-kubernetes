# apps/audiobookshelf/terraform/variables.tf
variable "namespace" {
  description = "AudioBookshelf namespace"
  type        = string
  default     = "audiobookshelf"
}

variable "image" {
  description = "AudioBookshelf Docker image"
  type        = string
  default     = "ghcr.io/advplyr/audiobookshelf:latest"
}

variable "replicas" {
  description = "Number of AudioBookshelf replicas"
  type        = number
  default     = 1
}

variable "config_storage" {
  description = "Storage size for AudioBookshelf config"
  type        = string
  default     = "5Gi"
}

variable "metadata_storage" {
  description = "Storage size for AudioBookshelf metadata"
  type        = string
  default     = "10Gi"
}

variable "audiobooks_storage" {
  description = "Storage size for audiobooks library"
  type        = string
  default     = "500Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "200m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "512Mi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "1000m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "2Gi"
}

variable "port" {
  description = "AudioBookshelf application port"
  type        = number
  default     = 80
}