# apps/llm/terraform/variables.tf
variable "namespace" {
  description = "LLM namespace"
  type        = string
  default     = "llm"
}

# Ollama Configuration
variable "ollama_image" {
  description = "Ollama Docker image"
  type        = string
  default     = "ollama/ollama:latest"
}

variable "ollama_request_storage" {
  description = "Storage for Ollama models"
  type        = string
  default     = "50Gi"
}

variable "ollama_request_cpu" {
  description = "CPU request for Ollama"
  type        = string
  default     = "2000m"
}

variable "ollama_request_memory" {
  description = "Memory request for Ollama"
  type        = string
  default     = "8Gi"
}

variable "ollama_limit_cpu" {
  description = "CPU limit for Ollama"
  type        = string
  default     = "8000m"
}

variable "ollama_limit_memory" {
  description = "Memory limit for Ollama"
  type        = string
  default     = "16Gi"
}

variable "ollama_port" {
  description = "Ollama API port"
  type        = number
  default     = 11434
}

# Open WebUI Configuration
variable "webui_image" {
  description = "Open WebUI Docker image"
  type        = string
  default     = "ghcr.io/open-webui/open-webui:v0.6.25"
}

variable "webui_request_cpu" {
  description = "CPU request for WebUI"
  type        = string
  default     = "500m"
}

variable "webui_request_memory" {
  description = "Memory request for WebUI"
  type        = string
  default     = "1Gi"
}

variable "webui_limit_cpu" {
  description = "CPU limit for WebUI"
  type        = string
  default     = "2000m"
}

variable "webui_limit_memory" {
  description = "Memory limit for WebUI"
  type        = string
  default     = "4Gi"
}

variable "webui_port" {
  description = "WebUI port"
  type        = number
  default     = 8080
}

variable "webui_data_storage" {
  description = "Storage for WebUI data"
  type        = string
  default     = "5Gi"
}

variable "namespace_enabled" {
  description = "Enable namespace"
  type        = bool
  default     = true
}
