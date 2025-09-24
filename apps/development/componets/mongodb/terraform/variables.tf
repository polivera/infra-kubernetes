# apps/MongoDB/terraform/variables.tf
variable "namespace" {
  description = "Flipflow namespace"
  type        = string
  default     = "flipflow"
}

variable "mongodb_image" {
  description = "MongoDB Image"
  type        = string
  default     = "mongo:4.2-bionic"
}

variable "mongodb_request_storage" {
  description = "Request storage for pv and pvc"
  type        = string
  default     = "20Gi"
}

variable "mongodb_request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "250m"
}

variable "mongodb_request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "512Mi"
}

variable "mongodb_limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "1000m"
}

variable "mongodb_limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "2Gi"
}

variable "mongodb_port" {
  description = "MongoDB Port"
  type        = number
  default     = 27017
}

variable "mongodb_external_port" {
  description = "MongoDB Port"
  type        = number
  default     = 11876
}
