variable "namespace" {
  description = "Jellyfin namespace"
  type        = string
  default     = "jellyfin"
}

variable "image" {
  description = "Jellyfin image"
  type        = string
  default     = "jellyfin/jellyfin:latest"
}

variable "request_memory" {
  description = "Jellyfin ram for jellyfin"
  type        = string
  default     = "2Gi"
}

variable "request_cpu" {
  description = "Jellyfin cpu for jellyfin"
  type        = string
  default     = "1000m"
}

variable "limit_memory" {
  description = "Jellyfin ram for jellyfin"
  type        = string
  default     = "4Gi"
}

variable "limit_cpu" {
  description = "Jellyfin cpu for jellyfin"
  type        = string
  default     = "2000m"
}

variable "config_storage" {
  description = "Jellyfing config storage size"
  type        = string
  default     = "10Gi"
}

variable "cache_storage" {
  description = "Jellyfing config storage size"
  type        = string
  default     = "20Gi"
}
variable "movies_storage" {
  description = "Jellyfing config storage size"
  type        = string
  default     = "500Gi"
}
variable "youtube_storage" {
  description = "Jellyfing config storage size"
  type        = string
  default     = "100Gi"
}
variable "anime_storage" {
  description = "Jellyfing config storage size"
  type        = string
  default     = "300Gi"
}

variable "port" {
  description = "Jellyfin port"
  type        = number
  default     = 8096
}

variable "hostname" {
  description = "Jellyfin hostname"
  type        = string
  default     = "jellyfin.vicugna.party"
}
