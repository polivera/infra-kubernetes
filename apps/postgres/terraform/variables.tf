variable "namespace" {
  description = "Postgres namespace"
  type = string
  default = "postgres"
}

variable "image" {
  description = "Postgres Image"
  type = string
  default = "postgres:17"
}

variable "request_storage" {
  description = "Request storage for pv and pvc"
  type = string
  default = "10Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type = string
  default = "300m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type = string
  default = "512Mi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type = string
  default = "1000m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type = string
  default = "2Gi"
}

variable "port" {
  description = "Postgres Port"
  type = string
  default = 5432
}


# Backup Configuration Variables
variable "backup_schedule" {
  description = "Cron schedule for PostgreSQL backups (default: daily at 2:00 AM)"
  type        = string
  default     = "23 9 * * *"
}

variable "backup_storage_size" {
  description = "Storage size for PostgreSQL backups"
  type        = string
  default     = "50Gi"
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "backup_request_cpu" {
  description = "CPU request for backup job"
  type        = string
  default     = "100m"
}

variable "backup_request_memory" {
  description = "Memory request for backup job"
  type        = string
  default     = "256Mi"
}

variable "backup_limit_cpu" {
  description = "CPU limit for backup job"
  type        = string
  default     = "500m"
}

variable "backup_limit_memory" {
  description = "Memory limit for backup job"
  type        = string
  default     = "512Mi"
}
