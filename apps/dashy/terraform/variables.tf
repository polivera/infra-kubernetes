# apps/dashy/terraform/variables.tf
variable "namespace" {
  description = "Dashy namespace"
  type        = string
  default     = "dashy"
}

variable "image" {
  description = "Dashy Docker image"
  type        = string
  default     = "lissy93/dashy:2.1.1"
}

variable "replicas" {
  description = "Number of Dashy replicas"
  type        = number
  default     = 1
}

variable "request_storage" {
  description = "Request storage for Dashy config"
  type        = string
  default     = "1Gi"
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
  description = "Dashy application port"
  type        = number
  default     = 80
}