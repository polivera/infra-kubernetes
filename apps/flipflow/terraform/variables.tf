# apps/mysql/terraform/variables.tf
variable "namespace" {
  description = "Flipflow namespace"
  type        = string
  default     = "flipflow"
}

variable "mysql_replicas" {
  description = "MySQL Replicas"
  type        = number
  default     = 1
}

variable "mysql_image" {
  description = "MySQL Image"
  type        = string
  default     = "mysql:8.4"
}

variable "mysql_request_storage" {
  description = "Request storage for pv and pvc"
  type        = string
  default     = "20Gi"
}

variable "mysql_request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "250m"
}

variable "mysql_request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "512Mi"
}

variable "mysql_limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "1000m"
}

variable "mysql_limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "2Gi"
}

variable "mysql_port" {
  description = "MySQL Port"
  type        = number
  default     = 3306
}

# --- Mongo ---
variable "enable_mongo" {
  type    = number
  default = 1
}

# PostgreSQL Variables (for metadata store)
variable "postgres_image" {
  description = "PostgreSQL Image"
  type        = string
  default     = "postgres:17"
}

variable "postgres_request_cpu" {
  description = "Request CPU for PostgreSQL"
  type        = string
  default     = "250m"
}

variable "postgres_request_memory" {
  description = "Request Memory for PostgreSQL"
  type        = string
  default     = "512Mi"
}

variable "postgres_limit_cpu" {
  description = "Limit CPU for PostgreSQL"
  type        = string
  default     = "1000m"
}

variable "postgres_limit_memory" {
  description = "Limit Memory for PostgreSQL"
  type        = string
  default     = "2Gi"
}

variable "postgres_storage_size" {
  description = "PostgreSQL storage size"
  type        = string
  default     = "10Gi"
}

variable "enable_zookeeper" {
  description = "Enable Zookeeper"
  type        = number
  default     = 0
}

variable "enable_postgres" {
  type    = number
  default = 0
}

variable "enable_druid" {
  type    = number
  default = 0
}

variable "enable_mysql" {
  type    = number
  default = 1
}
