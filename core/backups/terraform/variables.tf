# apps/backup/terraform/variables.tf
variable "namespace" {
  description = "Backup namespace"
  type        = string
  default     = "backup"
}

# Postgres backup configuration
variable "postgres_backup_enabled" {
  description = "Enable Postgres backup"
  type        = bool
  default     = true
}

variable "postgres_backup_schedule" {
  description = "Cron schedule for Postgres backup"
  type        = string
  default     = "0 2 * * *" # Daily at 2 AM
}

variable "postgres_backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
}

variable "postgres_host" {
  description = "Postgres host"
  type        = string
  default     = "postgres.postgres"
}

variable "postgres_port" {
  description = "Postgres port"
  type        = string
  default     = "5432"
}

variable "postgres_database" {
  description = "Postgres database name"
  type        = string
  default     = "postgres"
}

# MySQL backup configuration (for future use)
variable "mysql_backup_enabled" {
  description = "Enable MySQL backup"
  type        = bool
  default     = false
}

variable "mysql_backup_schedule" {
  description = "Cron schedule for MySQL backup"
  type        = string
  default     = "0 3 * * *" # Daily at 3 AM
}

variable "mysql_backup_retention_days" {
  description = "Number of days to retain MySQL backups"
  type        = number
  default     = 30
}

variable "mysql_host" {
  description = "MySQL host"
  type        = string
  default     = "mysql-headless.mysql.svc.cluster.local"
}

variable "mysql_port" {
  description = "MySQL port"
  type        = string
  default     = "3306"
}

# Storage configuration
variable "backup_storage_size" {
  description = "Storage size for backups"
  type        = string
  default     = "100Gi"
}

# Resource limits
variable "backup_cpu_request" {
  description = "CPU request for backup jobs"
  type        = string
  default     = "100m"
}

variable "backup_memory_request" {
  description = "Memory request for backup jobs"
  type        = string
  default     = "256Mi"
}

variable "backup_cpu_limit" {
  description = "CPU limit for backup jobs"
  type        = string
  default     = "500m"
}

variable "backup_memory_limit" {
  description = "Memory limit for backup jobs"
  type        = string
  default     = "512Mi"
}