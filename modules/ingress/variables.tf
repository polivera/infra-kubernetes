variable "ingress_namespace" {
  description = "Namespace where your certificate is located"
  type = string
}

variable "ingress_name" {
  description = "Name of the ingress"
  type = string
}

variable "external_name" {
  description = "Service name where the ingress should proxy"
  type = string
}

variable "cert_secret" {
  description = "Secret name of the certficate"
  type = string
}

variable "port" {
  description = "Port of the application"
  type = number
}

variable "hostname" {
  description = "Hostname for the service"
  type = string
}

variable "ssl_redirect" {
  description = "Redirect http to https"
  type = bool
  default = true
}

variable "proxy_body_size" {
  description = "Maximum allowed size of the client request body"
  type        = string
  default     = "100m"
}

variable "proxy_connect_timeout" {
  description = "Timeout for establishing a connection with a proxied server"
  type        = string
  default     = "600s"
}

variable "proxy_send_timeout" {
  description = "Timeout for transmitting a request to the proxied server"
  type        = string
  default     = "600s"
}

variable "proxy_read_timeout" {
  description = "Timeout for reading a response from the proxied server"
  type        = string
  default     = "600s"
}
