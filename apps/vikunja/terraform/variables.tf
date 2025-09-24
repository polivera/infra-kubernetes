variable "namespace" {
  description = "Vikunja namespace"
  type = string
  default = "vikunja"
}

variable "image" {
  description = "Image for vikunja"
  type = string
  default = "vikunja/vikunja:latest"
}

variable "port" {
  description = "Application port"
  type = number
  default = 3456
}

variable "storage_size" {
  description = "Storage size"
  type = string
  default = "20Gi"
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