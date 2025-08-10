# apps/qbittorrent/terraform/variables.tf
variable "namespace" {
  description = "qBittorrent namespace"
  type        = string
  default     = "qbittorrent"
}

variable "image" {
  description = "qBittorrent Docker image"
  type        = string
  default     = "lscr.io/linuxserver/qbittorrent:latest"
}

variable "replicas" {
  description = "Number of qBittorrent replicas"
  type        = number
  default     = 1
}

variable "config_storage" {
  description = "Storage size for qBittorrent config"
  type        = string
  default     = "5Gi"
}

variable "downloads_storage" {
  description = "Storage size for downloads"
  type        = string
  default     = "100Gi"
}

variable "request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "500m"
}

variable "request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "1Gi"
}

variable "limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "2000m"
}

variable "limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "4Gi"
}

variable "web_port" {
  description = "qBittorrent Web UI port"
  type        = number
  default     = 8080
}

variable "torrent_port" {
  description = "qBittorrent torrent port"
  type        = number
  default     = 6881
}

variable "puid" {
  description = "User ID for file permissions"
  type        = string
  default     = "1000"
}

variable "pgid" {
  description = "Group ID for file permissions"
  type        = string
  default     = "1000"
}

variable "timezone" {
  description = "Container timezone"
  type        = string
  default     = "Europe/Madrid"
}
