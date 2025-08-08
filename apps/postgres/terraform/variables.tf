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
  default = "2Gi"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type = string
  default = "1000m"
}

variable "port" {
  description = "Postgres Port"
  type = string
  default = 5432
}