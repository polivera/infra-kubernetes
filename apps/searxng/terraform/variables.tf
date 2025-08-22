# apps/searxng/terraform/variables.tf
variable "namespace" {
  description = "SearXNG namespace"
  type        = string
  default     = "searxng"
}

variable "image" {
  description = "SearXNG Docker image"
  type        = string
  default     = "docker.io/searxng/searxng:latest"
}

variable "config_storage" {
  description = "Storage size for SearXNG config"
  type        = string
  default     = "1Gi"
}

variable "cache_storage" {
  description = "Storage size for SearXNG cache"
  type        = string
  default     = "5Gi"
}

variable "request_cpu" {
  description = "Request CPU for SearXNG container"
  type        = string
  default     = "500m"
}

variable "request_memory" {
  description = "Request Memory for SearXNG container"
  type        = string
  default     = "512Mi"
}

variable "limit_cpu" {
  description = "Limit CPU for SearXNG container"
  type        = string
  default     = "2000m"
}

variable "limit_memory" {
  description = "Limit Memory for SearXNG container"
  type        = string
  default     = "2Gi"
}

variable "port" {
  description = "SearXNG application port"
  type        = number
  default     = 8080
}

variable "granian_workers" {
  description = "Number of Granian workers (not recommended to change)"
  type        = number
  default     = 2
}

variable "granian_blocking_threads" {
  description = "Number of Granian blocking threads (for WSGI applications)"
  type        = number
  default     = 8
}