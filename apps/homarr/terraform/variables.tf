variable "namespace" {
  description = "Homarr namespace"
  type = string
  default = "homarr"
}

variable "port" {
  description = "Application port"
  type = number
  default = 7575
}

variable "image" {
  description = "Homarr container image"
  type = string
  default = "ghcr.io/homarr-labs/homarr:latest"
}

variable "storage_size" {
  description = "Storage size for homarr config data"
  type = string
  default = "1Gi"
}

variable "limit_memory" {
  description = "limit pod memory"
  type        = string
  default     = "1Gi"
}

variable "limit_cpu" {
  description = "limit pod cpu"
  type        = string
  default     = "500m"
}


variable "request_memory" {
  description = "Requested pod memory"
  type        = string
  default     = "256Mi"
}

variable "request_cpu" {
  description = "Requested pod cpu"
  type        = string
  default     = "250m"
}