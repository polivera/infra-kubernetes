variable "namespace" {
  description = "Paperless namespace"
  type        = string
  default     = "paperless"
}

variable "image" {
  description = "Paperless Docker image"
  type        = string
  default     = "ghcr.io/paperless-ngx/paperless-ngx:latest"
}

variable "replicas" {
  description = "Number of Paperless replicas"
  type        = number
  default     = 1
}

variable "media_storage" {
  description = "Storage size for documents"
  type        = string
  default     = "100Gi"
}

variable "data_storage" {
  description = "Storage size for application data"
  type        = string
  default     = "10Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "500m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "1Gi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "2000m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "4Gi"
}

variable "port" {
  description = "Paperless application port"
  type        = number
  default     = 8000
}

# OCR and processing settings
variable "ocr_languages" {
  description = "OCR languages to install"
  type        = string
  default     = "eng spa deu fra ita"
}

variable "paperless_time_zone" {
  description = "Timezone for Paperless"
  type        = string
  default     = "Europe/Madrid"
}