variable "namespace" {
  description = "Kubernetes namespace for Heimdall"
  type        = string
  default     = "heimdall"
}

variable "hostname" {
  description = "Hostname for Heimdall"
  type        = string
  default     = "home.vicugna.party"
}

variable "cert_secret" {
  description = "Certificate secret storage"
  type = string
  default = "vicugna-party-wildcard-tls"
}

variable "ingress_namespace" {
  description = "Namespace for the ingresses"
  type = string
  default = "ingress"
}

variable "image" {
  description = "Container image"
  type = string
  default = "lscr.io/linuxserver/heimdall:latest"
}

variable "port" {
  description = "Application port"
  type = number
  default = 80
}

variable "storage_size" {
  description = "Heimdall requested storage size"
  type = string
  default = "1Gi"
}

variable "limit_memory" {
  description = "limit pod memory"
  type = string
  default = "512Mi"
}

variable "limit_cpu" {
  description = "limit pod cpu"
  type = string
  default = "500m"
}


variable "request_memory" {
  description = "Requested pod memory"
  type = string
  default = "128Mi"
}

variable "requested_cpu" {
  description = "Requested pod cpu"
  type = string
  default = "100m"
}
