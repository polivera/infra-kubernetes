# apps/metube/terraform/variables.tf
variable "namespace" {
  description = "Metube namespace"
  type        = string
  default     = "metube"
}

variable "image" {
  description = "Metube Docker image"
  type        = string
  default     = "alexta69/metube:latest"
}

variable "replicas" {
  description = "Number of Metube replicas"
  type        = number
  default     = 1
}

variable "downloads_storage" {
  description = "Storage size for downloads"
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
  description = "Metube application port"
  type        = number
  default     = 8081
}