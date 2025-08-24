# apps/navidrome/terraform/variables.tf
variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "navidrome"
}

variable "image" {
  description = "Navidrome Docker image"
  type        = string
  default     = "deluan/navidrome:latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "port" {
  description = "Navidrome port"
  type        = number
  default     = 4533
}

variable "log_level" {
  description = "Log level (error, warn, info, debug, trace)"
  type        = string
  default     = "info"
}

variable "scan_schedule" {
  description = "Music library scan schedule (cron format)"
  type        = string
  default     = "1h"
}

variable "transcoding_cache_size" {
  description = "Transcoding cache size"
  type        = string
  default     = "100MB"
}

variable "session_timeout" {
  description = "Session timeout"
  type        = string
  default     = "24h"
}

variable "enable_downloads" {
  description = "Enable music downloads"
  type        = bool
  default     = true
}

variable "enable_external_services" {
  description = "Enable external services (Last.fm, Spotify, etc.)"
  type        = bool
  default     = true
}

variable "music_readonly" {
  description = "Mount music volume as read-only"
  type        = bool
  default     = true
}

# Storage variables
variable "data_storage_size" {
  description = "Size of data storage"
  type        = string
  default     = "5Gi"
}

variable "music_storage_size" {
  description = "Size of music storage"
  type        = string
  default     = "100Gi"
}

# Resource limits
variable "request_memory" {
  description = "Memory request"
  type        = string
  default     = "256Mi"
}

variable "request_cpu" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "limit_memory" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "limit_cpu" {
  description = "CPU limit"
  type        = string
  default     = "500m"
}
