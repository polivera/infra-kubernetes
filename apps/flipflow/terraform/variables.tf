# apps/mysql/terraform/variables.tf
variable "namespace" {
  description = "Flipflow namespace"
  type        = string
  default     = "flipflow"
}

variable "mysql_replicas" {
  description = "MySQL Replicas"
  type        = number
  default     = 1
}

variable "mysql_image" {
  description = "MySQL Image"
  type        = string
  default     = "mysql:8.4"
}

variable "mysql_request_storage" {
  description = "Request storage for pv and pvc"
  type        = string
  default     = "20Gi"
}

variable "mysql_request_cpu" {
  description = "Request CPU for container"
  type        = string
  default     = "250m"
}

variable "mysql_request_memory" {
  description = "Request Memory for container"
  type        = string
  default     = "512Mi"
}

variable "mysql_limit_cpu" {
  description = "Limit CPU for container"
  type        = string
  default     = "1000m"
}

variable "mysql_limit_memory" {
  description = "Limit Memory for container"
  type        = string
  default     = "2Gi"
}

variable "mysql_port" {
  description = "MySQL Port"
  type        = number
  default     = 3306
}

# ---- DRUID VARIABLES ----
# Zookeeper Variables
variable "zookeeper_image" {
  description = "Zookeeper Image"
  type        = string
  default     = "bitnami/zookeeper:3.8"
}

variable "zookeeper_request_cpu" {
  description = "Request CPU for Zookeeper"
  type        = string
  default     = "200m"
}

variable "zookeeper_request_memory" {
  description = "Request Memory for Zookeeper"
  type        = string
  default     = "512Mi"
}

variable "zookeeper_limit_cpu" {
  description = "Limit CPU for Zookeeper"
  type        = string
  default     = "500m"
}

variable "zookeeper_limit_memory" {
  description = "Limit Memory for Zookeeper"
  type        = string
  default     = "1Gi"
}

# PostgreSQL Variables (for metadata store)
variable "postgres_image" {
  description = "PostgreSQL Image"
  type        = string
  default     = "postgres:17"
}

variable "postgres_request_cpu" {
  description = "Request CPU for PostgreSQL"
  type        = string
  default     = "250m"
}

variable "postgres_request_memory" {
  description = "Request Memory for PostgreSQL"
  type        = string
  default     = "512Mi"
}

variable "postgres_limit_cpu" {
  description = "Limit CPU for PostgreSQL"
  type        = string
  default     = "1000m"
}

variable "postgres_limit_memory" {
  description = "Limit Memory for PostgreSQL"
  type        = string
  default     = "2Gi"
}

variable "postgres_storage_size" {
  description = "PostgreSQL storage size"
  type        = string
  default     = "10Gi"
}

# Druid Coordinator Variables
variable "druid_coordinator_image" {
  description = "Druid Coordinator Image"
  type        = string
  default     = "apache/druid:32.0.0"
}

variable "druid_coordinator_request_cpu" {
  description = "Request CPU for Druid Coordinator"
  type        = string
  default     = "500m"
}

variable "druid_coordinator_request_memory" {
  description = "Request Memory for Druid Coordinator"
  type        = string
  default     = "1Gi"
}

variable "druid_coordinator_limit_cpu" {
  description = "Limit CPU for Druid Coordinator"
  type        = string
  default     = "1000m"
}

variable "druid_coordinator_limit_memory" {
  description = "Limit Memory for Druid Coordinator"
  type        = string
  default     = "2Gi"
}

# Druid Broker Variables
variable "druid_broker_request_cpu" {
  description = "Request CPU for Druid Broker"
  type        = string
  default     = "500m"
}

variable "druid_broker_request_memory" {
  description = "Request Memory for Druid Broker"
  type        = string
  default     = "1Gi"
}

variable "druid_broker_limit_cpu" {
  description = "Limit CPU for Druid Broker"
  type        = string
  default     = "1000m"
}

variable "druid_broker_limit_memory" {
  description = "Limit Memory for Druid Broker"
  type        = string
  default     = "2Gi"
}

# Druid Historical Variables
variable "druid_historical_request_cpu" {
  description = "Request CPU for Druid Historical"
  type        = string
  default     = "500m"
}

variable "druid_historical_request_memory" {
  description = "Request Memory for Druid Historical"
  type        = string
  default     = "1Gi"
}

variable "druid_historical_limit_cpu" {
  description = "Limit CPU for Druid Historical"
  type        = string
  default     = "1000m"
}

variable "druid_historical_limit_memory" {
  description = "Limit Memory for Druid Historical"
  type        = string
  default     = "2Gi"
}

variable "druid_historical_storage_size" {
  description = "Historical storage size"
  type        = string
  default     = "20Gi"
}

# Druid MiddleManager Variables
variable "druid_middlemanager_request_cpu" {
  description = "Request CPU for Druid MiddleManager"
  type        = string
  default     = "500m"
}

variable "druid_middlemanager_request_memory" {
  description = "Request Memory for Druid MiddleManager"
  type        = string
  default     = "1Gi"
}

variable "druid_middlemanager_limit_cpu" {
  description = "Limit CPU for Druid MiddleManager"
  type        = string
  default     = "2000m"
}

variable "druid_middlemanager_limit_memory" {
  description = "Limit Memory for Druid MiddleManager"
  type        = string
  default     = "4Gi"
}

variable "druid_middlemanager_storage_size" {
  description = "MiddleManager storage size"
  type        = string
  default     = "10Gi"
}

# Router Variables
variable "druid_router_port" {
  description = "Druid Router Port"
  type        = number
  default     = 8888
}



variable "enable_zookeeper" {
  description = "Enable Zookeeper"
  type        = number
  default     = 0
}

variable "enable_postgres" {
  type    = number
  default = 0
}

variable "enable_druid" {
  type    = number
  default = 0
}

variable "enable_mysql" {
  type    = number
  default = 1
}
