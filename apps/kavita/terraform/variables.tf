# apps/kavita/terraform/variables.tf
variable "namespace" {
  description = "Kavita namespace"
  type        = string
  default     = "kavita"
}

variable "image" {
  description = "Kavita Docker image"
  type        = string
  #default     = "kizaing/kavita:latest"
  default = "jvmilazz0/kavita:latest"
}

variable "config_storage" {
  description = "Storage size for Kavita config"
  type        = string
  default     = "2Gi"
}

variable "media_storage" {
  description = "Storage size for Kavita media library"
  type        = string
  default     = "100Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "200m"
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
  description = "Kavita application port"
  type        = number
  default     = 5000
}
