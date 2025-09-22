# Variables
variable "namespace" {
  description = "Gitea namespace"
  type        = string
  default     = "gitea"
}

variable "image" {
  description = "Gitea Docker image"
  type        = string
  default     = "gitea/gitea:1.21"
}

variable "storage_size" {
  description = "Storage size for Gitea data"
  type        = string
  default     = "50Gi"
}

variable "ssh_external_ip" {
  description = "External IP for SSH access via MetalLB"
  type        = string
  default     = "192.168.0.122"
}

variable "http_port" {
  description = "Application internal web port"
  type        = number
  default     = 3000
}

variable "ssh_port" {
  description = "Application internal ssh port"
  type        = number
  default     = 2222
}

variable "internal_ssh_port" {
  description = "container ssh port"
  type = number
  default = 22
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