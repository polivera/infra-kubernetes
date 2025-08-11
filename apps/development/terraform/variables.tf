# apps/development/terraform/variables.tf
variable "namespace" {
  description = "Development namespace"
  type        = string
  default     = "development"
}

# PostgreSQL Variables
variable "postgres_image" {
  description = "PostgreSQL Image"
  type        = string
  default     = "postgres:17"
}

variable "postgres_request_storage" {
  description = "Request storage for PostgreSQL PV and PVC"
  type        = string
  default     = "20Gi"
}

variable "postgres_request_cpu" {
  description = "Request CPU for PostgreSQL container"
  type        = string
  default     = "500m"
}

variable "postgres_request_memory" {
  description = "Request Memory for PostgreSQL container"
  type        = string
  default     = "1Gi"
}

variable "postgres_limit_cpu" {
  description = "Limit CPU for PostgreSQL container"
  type        = string
  default     = "2000m"
}

variable "postgres_limit_memory" {
  description = "Limit Memory for PostgreSQL container"
  type        = string
  default     = "4Gi"
}

variable "postgres_port" {
  description = "PostgreSQL Port"
  type        = number
  default     = 5432
}

variable "postgres_external_ip" {
  description = "External IP for PostgreSQL via MetalLB"
  type        = string
  default     = "192.168.0.125"
}

# Redis Variables
variable "redis_image" {
  description = "Redis Image"
  type        = string
  default     = "redis:7-alpine"
}

variable "redis_request_storage" {
  description = "Request storage for Redis PV and PVC"
  type        = string
  default     = "10Gi"
}

variable "redis_request_cpu" {
  description = "Request CPU for Redis container"
  type        = string
  default     = "200m"
}

variable "redis_request_memory" {
  description = "Request Memory for Redis container"
  type        = string
  default     = "512Mi"
}

variable "redis_limit_cpu" {
  description = "Limit CPU for Redis container"
  type        = string
  default     = "1000m"
}

variable "redis_limit_memory" {
  description = "Limit Memory for Redis container"
  type        = string
  default     = "1Gi"
}

variable "redis_port" {
  description = "Redis Port"
  type        = number
  default     = 6379
}

variable "redis_external_ip" {
  description = "External IP for Redis via MetalLB"
  type        = string
  default     = "192.168.0.126"
}