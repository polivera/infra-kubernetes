variable "headless" {
  description = "Need headless service"
  type = bool
  default = false
}

variable "external" {
  description = "Need metallb external service"
  type = bool
  default = false
}

variable "external_ip" {
  description = "If declared external, give the metallb ip to assign"
  type = string
  default = ""
}

variable "external_allowed_cdir" {
  description = "Allowed IPs for external access"
  type = list(string)
  default = ["192.168.0.0/24", "10.0.0.0/8"]
}

variable "service_type" {
  description = "Service Type"
  type = string
  default = "ClusterIP"
}

variable "name" {
  description = "Service Name"
  type = string
}

variable "namespace" {
  description = "Service Namespace"
  type = string
}

variable "port" {
  description = "Service port"
  type = number
}

variable "target_port" {
  description = "Service Target Port"
  type = number
}