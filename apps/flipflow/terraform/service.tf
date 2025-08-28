# apps/mysql/terraform/service.tf
module "mysql_service" {
  source      = "../../../modules/services"
  name        = "mysql"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.122"
  port        = var.mysql_port
  target_port = var.mysql_port
}

module "zookeeper_service" {
  source      = "../../../modules/services"
  name        = "zookeeper"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 2181
  target_port = 2181
}

module "postgres_service" {
  source      = "../../../modules/services"
  name        = "postgres"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 5432
  target_port = 5432
}

module "druid_coordinator_service" {
  source      = "../../../modules/services"
  name        = "druid-coordinator"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8081
  target_port = 8081
}

module "druid_broker_service" {
  source      = "../../../modules/services"
  name        = "druid-broker"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8082
  target_port = 8082
}

module "druid_historical_service" {
  source      = "../../../modules/services"
  name        = "druid-historical"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8083
  target_port = 8083
}

module "druid_middlemanager_service" {
  source      = "../../../modules/services"
  name        = "druid-middlemanager"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = 8091
  target_port = 8091
}

module "druid_router_service" {
  source      = "../../../modules/services"
  name        = "druid-router"
  namespace   = kubernetes_namespace.flipflow.metadata[0].name
  headless    = false
  port        = var.druid_router_port
  target_port = var.druid_router_port
}