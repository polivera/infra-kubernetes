# apps/docmost/terraform/variables.tf
variable "namespace" {
  description = "Docmost namespace"
  type        = string
  default     = "docmost"
}

variable "image" {
  description = "Docmost Docker image"
  type        = string
  default     = "docmost/docmost:latest"
}

variable "replicas" {
  description = "Number of Docmost replicas"
  type        = number
  default     = 1
}

variable "request_storage" {
  description = "Request storage for uploads"
  type        = string
  default     = "10Gi"
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
  default     = "1Gi"
}

variable "port" {
  description = "Docmost application port"
  type        = number
  default     = 3000
}

# Mail configuration
variable "mail_driver" {
  description = "Mail driver (smtp, sendmail, etc.)"
  type        = string
  default     = "smtp"
}

variable "mail_host" {
  description = "SMTP host"
  type        = string
  default     = "smtp.gmail.com"
}

variable "mail_port" {
  description = "SMTP port"
  type        = number
  default     = 587
}

variable "mail_from_address" {
  description = "From email address"
  type        = string
  default     = "noreply@vicugna.party"
}

variable "mail_from_name" {
  description = "From name"
  type        = string
  default     = "Docmost"
}