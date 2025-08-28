# Coordinator
resource "kubernetes_deployment" "druid_coordinator" {
  count = var.enable_druid
  metadata {
    name      = "druid-coordinator"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "druid-coordinator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "druid-coordinator"
      }
    }

    template {
      metadata {
        labels = {
          app = "druid-coordinator"
        }
      }

      spec {
        container {
          name  = "druid-coordinator"
          image = var.druid_coordinator_image

          command = [
            "/opt/druid/bin/run-druid",
            "coordinator"
          ]

          port {
            container_port = 8081
            name          = "http"
          }

          env {
            name  = "DRUID_XMX"
            value = "1g"
          }
          env {
            name  = "DRUID_XMS"
            value = "1g"
          }
          env {
            name  = "DRUID_MAXNEWSIZE"
            value = "250m"
          }
          env {
            name  = "DRUID_NEWSIZE"
            value = "250m"
          }

          resources {
            requests = {
              memory = var.druid_coordinator_request_memory
              cpu    = var.druid_coordinator_request_cpu
            }
            limits = {
              memory = var.druid_coordinator_limit_memory
              cpu    = var.druid_coordinator_limit_cpu
            }
          }

          volume_mount {
            name       = "common-config"
            mount_path = "/opt/druid/conf/_common"
            read_only  = true
          }

          volume_mount {
            name       = "coordinator-config"
            mount_path = "/opt/druid/conf/coordinator"
            read_only  = true
          }

          volume_mount {
            name       = "shared-data"
            mount_path = "/opt/shared"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = 8081
            }
            initial_delay_seconds = 60
            period_seconds        = 30
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = 8081
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }

        volume {
          name = "common-config"
          config_map {
            name = kubernetes_config_map.druid_common.metadata[0].name
          }
        }

        volume {
          name = "coordinator-config"
          config_map {
            name = kubernetes_config_map.druid_coordinator.metadata[0].name
          }
        }

        volume {
          name = "shared-data"
          persistent_volume_claim {
            claim_name = module.druid_shared_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.postgres,
    kubernetes_deployment.zookeeper,
    module.druid_shared_storage
  ]
}

# Broker
resource "kubernetes_deployment" "druid_broker" {
  count = var.enable_druid
  metadata {
    name      = "druid-broker"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "druid-broker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "druid-broker"
      }
    }

    template {
      metadata {
        labels = {
          app = "druid-broker"
        }
      }

      spec {
        container {
          name  = "druid-broker"
          image = var.druid_coordinator_image

          command = [
            "/opt/druid/bin/run-druid",
            "broker"
          ]

          port {
            container_port = 8082
            name          = "http"
          }

          resources {
            requests = {
              memory = var.druid_broker_request_memory
              cpu    = var.druid_broker_request_cpu
            }
            limits = {
              memory = var.druid_broker_limit_memory
              cpu    = var.druid_broker_limit_cpu
            }
          }

          volume_mount {
            name       = "common-config"
            mount_path = "/opt/druid/conf/_common"
            read_only  = true
          }

          volume_mount {
            name       = "broker-config"
            mount_path = "/opt/druid/conf/broker"
            read_only  = true
          }

          volume_mount {
            name       = "shared-data"
            mount_path = "/opt/shared"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = 8082
            }
            initial_delay_seconds = 90
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = 8082
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }

        volume {
          name = "common-config"
          config_map {
            name = kubernetes_config_map.druid_common.metadata[0].name
          }
        }

        volume {
          name = "broker-config"
          config_map {
            name = kubernetes_config_map.druid_broker.metadata[0].name
          }
        }

        volume {
          name = "shared-data"
          persistent_volume_claim {
            claim_name = module.druid_shared_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.druid_coordinator
  ]
}
# Historical
resource "kubernetes_deployment" "druid_historical" {
  count = var.enable_druid
  metadata {
    name      = "druid-historical"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "druid-historical"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "druid-historical"
      }
    }

    template {
      metadata {
        labels = {
          app = "druid-historical"
        }
      }

      spec {
        container {
          name  = "druid-historical"
          image = var.druid_coordinator_image

          command = [
            "/opt/druid/bin/run-druid",
            "historical"
          ]

          port {
            container_port = 8083
            name          = "http"
          }

          resources {
            requests = {
              memory = var.druid_historical_request_memory
              cpu    = var.druid_historical_request_cpu
            }
            limits = {
              memory = var.druid_historical_limit_memory
              cpu    = var.druid_historical_limit_cpu
            }
          }

          volume_mount {
            name       = "common-config"
            mount_path = "/opt/druid/conf/_common"
            read_only  = true
          }

          volume_mount {
            name       = "historical-config"
            mount_path = "/opt/druid/conf/historical"
            read_only  = true
          }

          volume_mount {
            name       = "shared-data"
            mount_path = "/opt/shared"
          }

          volume_mount {
            name       = "segment-cache"
            mount_path = "/opt/druid/var/druid/segment-cache"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = 8083
            }
            initial_delay_seconds = 90
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = 8083
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

        }

        volume {
          name = "common-config"
          config_map {
            name = kubernetes_config_map.druid_common.metadata[0].name
          }
        }

        volume {
          name = "historical-config"
          config_map {
            name = kubernetes_config_map.druid_historical.metadata[0].name
          }
        }

        volume {
          name = "shared-data"
          persistent_volume_claim {
            claim_name = module.druid_shared_storage.pvc_name
          }
        }

        volume {
          name = "segment-cache"
          persistent_volume_claim {
            claim_name = module.druid_historical_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.druid_coordinator
  ]
}

# MiddleManager
resource "kubernetes_deployment" "druid_middlemanager" {
  count = var.enable_druid
  metadata {
    name      = "druid-middlemanager"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "druid-middlemanager"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "druid-middlemanager"
      }
    }

    template {
      metadata {
        labels = {
          app = "druid-middlemanager"
        }
      }

      spec {
        container {
          name  = "druid-middlemanager"
          image = var.druid_coordinator_image

          command = [
            "/opt/druid/bin/run-druid",
            "middleManager"
          ]

          port {
            container_port = 8091
            name          = "http"
          }

          resources {
            requests = {
              memory = var.druid_middlemanager_request_memory
              cpu    = var.druid_middlemanager_request_cpu
            }
            limits = {
              memory = var.druid_middlemanager_limit_memory
              cpu    = var.druid_middlemanager_limit_cpu
            }
          }

          volume_mount {
            name       = "common-config"
            mount_path = "/opt/druid/conf/_common"
            read_only  = true
          }

          volume_mount {
            name       = "middlemanager-config"
            mount_path = "/opt/druid/conf/druid/single-server/micro-quickstart/middleManager"
            read_only  = true
          }

          volume_mount {
            name       = "shared-data"
            mount_path = "/opt/shared"
          }

          volume_mount {
            name       = "task-data"
            mount_path = "/opt/druid/var"
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = 8091
            }
            initial_delay_seconds = 60
            period_seconds        = 30
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = 8091
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }

        volume {
          name = "common-config"
          config_map {
            name = kubernetes_config_map.druid_common.metadata[0].name
          }
        }

        volume {
          name = "middlemanager-config"
          config_map {
            name = kubernetes_config_map.druid_middlemanager.metadata[0].name
          }
        }

        volume {
          name = "shared-data"
          persistent_volume_claim {
            claim_name = module.druid_shared_storage.pvc_name
          }
        }

        volume {
          name = "task-data"
          persistent_volume_claim {
            claim_name = module.druid_middlemanager_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.druid_coordinator
  ]
}

# Router
resource "kubernetes_deployment" "druid_router" {
  count = var.enable_druid
  metadata {
    name      = "druid-router"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "druid-router"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "druid-router"
      }
    }

    template {
      metadata {
        labels = {
          app = "druid-router"
        }
      }

      spec {
        container {
          name  = "druid-router"
          image = var.druid_coordinator_image

          command = [
            "/opt/druid/bin/run-druid",
            "router"
          ]

          port {
            container_port = var.druid_router_port
            name          = "http"
          }

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          volume_mount {
            name       = "common-config"
            mount_path = "/opt/druid/conf/_common"
            read_only  = true
          }

          volume_mount {
            name       = "router-config"
            mount_path = "/opt/druid/conf/druid/single-server/micro-quickstart/router"
            read_only  = true
          }

          liveness_probe {
            http_get {
              path = "/status/health"
              port = var.druid_router_port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
          }

          readiness_probe {
            http_get {
              path = "/status/health"
              port = var.druid_router_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }

        volume {
          name = "common-config"
          config_map {
            name = kubernetes_config_map.druid_common.metadata[0].name
          }
        }

        volume {
          name = "router-config"
          config_map {
            name = kubernetes_config_map.druid_router.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.druid_broker,
    kubernetes_deployment.druid_coordinator
  ]
}