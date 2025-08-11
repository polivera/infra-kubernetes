# monitoring/terraform/variables.tf
variable "namespace" {
  description = "Monitoring namespace"
  type        = string
  default     = "monitoring"
}

# Storage configurations
variable "prometheus_storage_size" {
  description = "Storage size for Prometheus data"
  type        = string
  default     = "50Gi"
}

variable "grafana_storage_size" {
  description = "Storage size for Grafana data"
  type        = string
  default     = "10Gi"
}

variable "loki_storage_size" {
  description = "Storage size for Loki logs"
  type        = string
  default     = "100Gi"
}

# Prometheus resource configurations
variable "prometheus_memory_request" {
  description = "Memory request for Prometheus"
  type        = string
  default     = "2Gi"
}

variable "prometheus_memory_limit" {
  description = "Memory limit for Prometheus"
  type        = string
  default     = "4Gi"
}

variable "prometheus_cpu_request" {
  description = "CPU request for Prometheus"
  type        = string
  default     = "500m"
}

variable "prometheus_cpu_limit" {
  description = "CPU limit for Prometheus"
  type        = string
  default     = "2000m"
}

# Grafana resource configurations
variable "grafana_memory_request" {
  description = "Memory request for Grafana"
  type        = string
  default     = "256Mi"
}

variable "grafana_memory_limit" {
  description = "Memory limit for Grafana"
  type        = string
  default     = "512Mi"
}

variable "grafana_cpu_request" {
  description = "CPU request for Grafana"
  type        = string
  default     = "100m"
}

variable "grafana_cpu_limit" {
  description = "CPU limit for Grafana"
  type        = string
  default     = "500m"
}

# Loki resource configurations
variable "loki_memory_request" {
  description = "Memory request for Loki"
  type        = string
  default     = "1Gi"
}

variable "loki_memory_limit" {
  description = "Memory limit for Loki"
  type        = string
  default     = "2Gi"
}

variable "loki_cpu_request" {
  description = "CPU request for Loki"
  type        = string
  default     = "200m"
}

variable "loki_cpu_limit" {
  description = "CPU limit for Loki"
  type        = string
  default     = "1000m"
}