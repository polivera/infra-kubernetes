# apps/redis/terraform/variables.tf
variable "namespace" {
  description = "Redis namespace"
  type        = string
  default     = "redis"
}

variable "image" {
  description = "Redis Image"
  type        = string
  default     = "redis:7-alpine"
}

variable "request_storage" {
  description = "Request storage for pv and pvc"
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
  description = "Redis Port"
  type        = number
  default     = 6379
}
