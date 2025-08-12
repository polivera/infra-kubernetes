variable "namespace" {
  description = "Planka namespace"
  type        = string
  default     = "planka"
}

variable "image" {
  description = "Planka Docker image"
  type        = string
  default     = "ghcr.io/plankanban/planka:latest"
}

variable "replicas" {
  description = "Number of Planka replicas"
  type        = number
  default     = 1
}

variable "request_storage" {
  description = "Request storage for Planka uploads"
  type        = string
  default     = "5Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "100m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "256Mi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "500m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "512Mi"
}

variable "port" {
  description = "Planka application port"
  type        = number
  default     = 1337
}