variable "headless" {
  description = "Need headless service"
  type = bool
  default = false
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