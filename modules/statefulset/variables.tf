variable "namespace" {
  description = "Deployment namespace"
  type        = string
}

variable "app_name" {
  description = "Name of the application of the deployment"
  type        = string
}

variable "service_name" {
  description = "Name of the stateful service"
  type        = string
}

variable "image" {
  description = "Deployment image"
  type        = string
}

variable "ports" {
  description = "Stateful set ports"
  type = list(object({
    port     = number
    name     = string
    protocol = string
  }))
}

variable "replicas" {
  description = "Deployment replicas"
  type        = number
  default     = 1
}

variable "dns_nameserver" {
  description = "Deployment nameservers"
  type        = list(string)
  default     = ["10.43.0.10", "192.168.0.1"]
}

variable "dns_searches" {
  description = "DNS search domains"
  type        = list(string)
  default     = ["svc.cluster.local", "cluster.local"]
}

variable "envs" {
  description = "Environment variables with additional configuration"
  type = map(object({
    value     = string
    sensitive = optional(bool, false)
  }))
  default = {}
}

variable "env_secrets" {
  description = "Environment variables with additional configuration"
  type = map(object({
    sensitive   = optional(bool, false)
    secret_name = string
    secret_key  = string
  }))
  default = {}
}

variable "env_configs" {
  description = "Environment variables with additional configuration"
  type = map(object({
    sensitive   = optional(bool, false)
    config_name = string
    config_key  = string
  }))
  default = {}
}

variable "mounts" {
  description = "Mount points for the deploy"
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
}

variable "claims" {
  description = "PVCs for the deployment"
  type = list(object({
    name       = string
    claim_name = string
  }))
}

variable "command_start" {
  description = "Startup command for the stateful set"
  type = list(string)
  default = []
}

variable "volume_configs" {
  description = "Volume claims"
  type = list(object({
    name        = string
    config_name = string
    items = optional(
      object(
        {
          key  = string
          path = string
        }
      )
    )
  }))
}

variable "http_probe" {
  description = "Set the path for liveness and readiness probe"
  type        = string
  default     = null
}

variable "http_probe_port" {
  description = "Port for probing"
  type        = number
  default     = null
}

variable "command_probe" {
  description = "Set the path for liveness and readiness probe"
  type        = list(string)
  default     = null
}

variable "tcp_probe" {
  description = "Port to set a readiness and start probe on port"
  type = number
  default = null
}

# Resource limits
variable "request_memory" {
  description = "Memory request"
  type        = string
  default     = "256Mi"
}

variable "request_cpu" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "limit_memory" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "limit_cpu" {
  description = "CPU limit"
  type        = string
  default     = "500m"
}

variable "security_context" {
  description = "Security context configuration"
  type = object({
    fs_group = number
  })
  default = null
}

variable "gpu_node_hostname" {
  description = "Hostname of the GPU node"
  type        = string
  default     = ""
}
