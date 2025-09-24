# apps/mysql/terraform/variables.tf
variable "namespace" {
  description = "development namespace"
  type        = string
  default     = "development"
}

variable "mysql_image" {
  description = "MySQL Image"
  type        = string
  default     = "mysql:8.4"
}

variable "mysql_app_name" {
  description = "Application name for mysql development"
  type = string
  default = "development-mysql"
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

variable "mysql_external_port" {
  description = "MySQL Port"
  type        = number
  default     = 10306
}
