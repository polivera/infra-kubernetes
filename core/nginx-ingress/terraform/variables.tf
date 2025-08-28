variable "namespace" {
  description = "Kubernetes namespace for NGINX Ingress"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_load_balancer_ip" {
  description = "IP address for DNS service (MetalLB)"
  type        = string
  default     = "192.168.0.121"
}

variable "metallb_pool" {
  description = "MetalLB address pool name"
  type        = string
  default     = "default-pool"
}

variable "ssl_redirect" {
  description = "SSL redirect if http request"
  type = string
  default = true
}

variable "forward_headers" {
  description = "Forward request headers"
  type = string
  default = true
}

variable "full_forwarded_for" {
  description = "Full forwarded for header"
  type = string
  default = true
}

variable "request_memory" {
  description = "Requested amount of memory"
  type = string
  default = "90Mi"
}

variable "request_cpu" {
  description = "Requested amount of CPU"
  type = string
  default = "100m"
}

variable "limit_memory" {
  description = "Limit of memory that the pod can request"
  type = string
  default = "512Mi"
}

variable "limit_cpu" {
  description = "Limit of cpu that the pod can request"
  type = string
  default = "500"
}

# Global timeout and upload settings
variable "proxy_connect_timeout" {
  description = "Global proxy connect timeout"
  type        = string
  default     = "600"
}

variable "proxy_send_timeout" {
  description = "Global proxy send timeout"
  type        = string
  default     = "600"
}

variable "proxy_read_timeout" {
  description = "Global proxy read timeout"
  type        = string
  default     = "600"
}

variable "proxy_body_size" {
  description = "Global maximum request body size"
  type        = string
  default     = "100m"
}
