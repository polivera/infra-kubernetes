# Zookeeper 
module "zookeeper_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "zookeeper"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 2181
  target_port = 2181
}

# Postgres
module "postgres_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "postgres"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 5432
  target_port = 5432
}

module "druid_coordinator_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "druid-coordinator"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8081
  target_port = 8081
}

module "druid_broker_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "druid-broker"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8082
  target_port = 8082
}

module "druid_historical_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "druid-historical"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8083
  target_port = 8083
}

module "druid_middlemanager_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "druid-middlemanager"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8091
  target_port = 8091
}

module "druid_router_service" {
  count       = var.enable_druid
  source      = "../../../modules/services"
  name        = "druid-router"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = var.druid_router_port
  target_port = var.druid_router_port
}
