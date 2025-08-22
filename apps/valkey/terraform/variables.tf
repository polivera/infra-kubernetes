# apps/valkey/terraform/variables.tf
variable "namespace" {
  description = "Valkey namespace"
  type        = string
  default     = "valkey"
}

variable "image" {
  description = "Valkey Docker image"
  type        = string
  default     = "valkey/valkey:7.2"
}

variable "port" {
  description = "Valkey port"
  type        = number
  default     = 6379
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "storage_size" {
  description = "Storage size for Valkey data"
  type        = string
  default     = "10Gi"
}

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

variable "password" {
  description = "Valkey password"
  type        = string
  sensitive   = true
  default     = ""
}
