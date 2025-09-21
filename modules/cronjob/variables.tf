variable "namespace" {
  description = "Cron job namespace"
  type = string

}

variable "app_name" {
  description = "Application name for the cron"
  type = string
}

variable "schedule" {
  description = "Cronjob schedule"
  type = string
  default = "23 59 * * *"
}

variable "restart_policy" {
  description = "Cronjob restart policy"
  type = string
  default = "OnFailure"
}

variable "image" {
  description = "Cron job image"
  type = string
}

variable "command" {
  description = "Cron job command"
  type = list(string)
}

variable "arguments" {
  description = "Cron job command arguments"
  type = list(string)
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

variable "successful_jobs_history_limit" {
  description = ""
  type = number
  default = 3
}

variable "failed_jobs_history_limit" {
  description = ""
  type = number
  default = 1
}

variable "concurrency_policy" {
  description = ""
  type = string
  default = "Forbid"
}

variable "starting_deadline_seconds" {
  description = ""
  type = number
  default = 300
}