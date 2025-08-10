# apps/mysql/terraform/variables.tf
variable "namespace" {
  description = "MySQL namespace"
  type        = string
  default     = "mysql"
}

variable "image" {
  description = "MySQL Image"
  type        = string
  default     = "mysql:8.0"
}

variable "request_storage" {
  description = "Request storage for pv and pvc"
  type        = string
  default     = "20Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "250m"
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
  description = "MySQL Port"
  type        = number
  default     = 3306
}