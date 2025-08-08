# ============================================
# modules/static-nfs-volume/variables.tf
# ============================================
variable "app_name" {
  description = "Application name (used for paths and naming)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for PVC"
  type        = string
}

variable "size" {
  description = "Volume size"
  type        = string
  default     = "5Gi"
}

variable "pool" {
  description = "Storage pool type"
  type        = string
  default     = "slow"

  validation {
    condition     = contains(["slow", "fast"], var.pool)
    error_message = "Pool must be either 'slow' or 'fast'."
  }
}

variable "subpath" {
  description = "Optional subpath under the app folder"
  type        = string
  default     = ""
}

variable "force_path" {
  description = "Force a given path"
  type        = string
  default     = ""
}

variable "nfs_server" {
  description = "NFS server IP"
  type        = string
  default     = "192.168.0.11"
}

variable "access_modes" {
  description = "Access modes for the volume"
  type        = list(string)
  default     = ["ReadWriteMany"]
}
