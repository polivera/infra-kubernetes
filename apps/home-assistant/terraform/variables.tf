# apps/home-assistant/terraform/variables.tf
variable "namespace" {
  description = "Home Assistant namespace"
  type        = string
  default     = "homeassistant"
}

variable "image" {
  description = "Home Assistant Docker image"
  type        = string
  default     = "ghcr.io/home-assistant/home-assistant:stable"
}

variable "replicas" {
  description = "Number of Home Assistant replicas"
  type        = number
  default     = 1
}

variable "config_storage" {
  description = "Storage size for Home Assistant config"
  type        = string
  default     = "10Gi"
}

variable "storage_pool" {
  description = "Storage pool type (slow for config files, fast for high-frequency databases)"
  type        = string
  default     = "slow"

  validation {
    condition     = contains(["slow", "fast"], var.storage_pool)
    error_message = "Storage pool must be either 'slow' or 'fast'."
  }
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "500m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "1Gi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "2000m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "4Gi"
}

variable "port" {
  description = "Home Assistant port"
  type        = number
  default     = 8123
}

variable "privileged" {
  description = "Run container in privileged mode for device access"
  type        = bool
  default     = true
}