# --- Chrome ---
variable "chrome_replicas" {
  type    = number
  default = 1
}

variable "chrome_image" {
  description = "Chrome container image"
  type        = string
  default     = "zenika/alpine-chrome:latest"
}

variable "chrome_headless_mode" {
  description = "Run Chrome in headless mode"
  type        = bool
  default     = true
}

variable "chrome_port" {
  description = "Chrome DevTools Protocol port"
  type        = number
  default     = 9222
}

variable "chrome_request_memory" {
  description = "Requested memory for Chrome container"
  type        = string
  default     = "512Mi"
}

variable "chrome_request_cpu" {
  description = "Requested CPU for Chrome container"
  type        = string
  default     = "250m"
}

variable "chrome_limit_memory" {
  description = "Memory limit for Chrome container"
  type        = string
  default     = "1Gi"
}

variable "chrome_limit_cpu" {
  description = "CPU limit for Chrome container"
  type        = string
  default     = "500m"
}
