# Gitea StatefulSet
module "gitea_stateful_set" {
  source       = "../../../modules/statefulset"
  app_name     = var.namespace
  namespace    = var.namespace
  service_name = "${var.namespace}-headless"
  image        = var.image
  envs = {
    USER_UID = {
      value = "1000"
    },
    USER_GID = {
      value = "1000"
    }
  }
  env_secrets = {
    GITEA__database__PASSWD = {
      secret_name = kubernetes_secret.gitea.metadata[0].name
      secret_key  = "database-password"
    },
    GITEA__security__SECRET_KEY = {
      secret_name = kubernetes_secret.gitea.metadata[0].name
      secret_key  = "secret-key"
    }
  }
  ports = [
    {
      port = var.http_port
      name = "http"
    },
    {
      port = var.ssh_port
      name = "ssh"
    }
  ]
  mounts = [
    {
      name       = "gitea-data"
      mount_path = "/data"
    },
    {
      name       = "gitea-config"
      mount_path = "/etc/gitea"
    }
  ]
  claims = [
    {
      name = "gitea-data"
      claim_name =module.gitea_storage.pvc_name
    }
  ]

  volume_configs = [
    {
      name ="gitea-config" ,
      claim_name = kubernetes_config_map.gitea.metadata[0].name
    }
  ]
}

resource "kubernetes_stateful_set" "gitea" {
  metadata {
    name      = "gitea"
    namespace = var.namespace
    labels = {
      app = "gitea"
    }
  }

  spec {
    service_name = "gitea-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "gitea"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitea"
        }
      }

      spec {
        security_context {
          fs_group = 1000
        }

        container {
          name  = "gitea"
          image = var.image

          env {
            name  = "USER_UID"
            value = "1000"
          }

          env {
            name  = "USER_GID"
            value = "1000"
          }

          env {
            name = "GITEA__database__PASSWD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.gitea.metadata[0].name
                key  = "database-password"
              }
            }
          }

          env {
            name = "GITEA__security__SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.gitea.metadata[0].name
                key  = "secret-key"
              }
            }
          }

          port {
            container_port = var.http_port
            name           = "http"
          }

          port {
            container_port = var.ssh_port
            name           = "ssh"
          }

          volume_mount {
            name       = "gitea-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "gitea-config"
            mount_path = "/etc/gitea"
          }

          resources {
            requests = {
              memory = var.request_memory
              cpu    = var.request_cpu
            }
            limits = {
              memory = var.limit_memory
              cpu    = var.limit_cpu
            }
          }

          liveness_probe {
            http_get {
              path = "/api/healthz"
              port = var.http_port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/api/healthz"
              port = var.http_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }
        }

        volume {
          name = "gitea-data"
          persistent_volume_claim {
            claim_name = module.gitea_storage.pvc_name
          }
        }

        volume {
          name = "gitea-config"
          config_map {
            name = kubernetes_config_map.gitea.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    module.gitea_storage,
    kubernetes_config_map.gitea,
    kubernetes_secret.gitea
  ]
}
