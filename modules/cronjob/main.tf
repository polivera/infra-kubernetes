# CronJob for automated PostgreSQL backups
resource "kubernetes_cron_job_v1" "this" {
  metadata {
    name      = "${var.app_name}-cronjob"
    namespace = var.namespace
    labels = {
      app = "${var.app_name}-cronjob"
    }
  }

  spec {
    schedule = var.schedule

    job_template {
      metadata {
        name = "${var.app_name}-cronjob"
      }

      spec {
        template {
          metadata {
            name = "${var.app_name}-cronjob"
          }

          spec {
            restart_policy = var.restart_policy

            container {
              name  = "${var.app_name}-cronjob"
              image = var.image # Use same postgres image

              dynamic "env" {
                for_each = var.envs
                content {
                  name  = env.key
                  value = env.value.value
                }
              }

              dynamic "env" {
                for_each = var.env_secrets
                content {
                  name = env.key
                  value_from {
                    secret_key_ref {
                      name = env.value.secret_name
                      key  = env.value.secret_key
                    }
                  }
                }
              }

              dynamic "env" {
                for_each = var.env_configs
                content {
                  name = env.key
                  value_from {
                    config_map_key_ref {
                      name = env.value.config_name
                      key  = env.value.config_key
                    }
                  }
                }
              }

              command = var.command
              args = var.arguments

              dynamic "volume_mount" {
                for_each = var.mounts
                content {
                  name       = volume_mount.value.name
                  mount_path = volume_mount.value.mount_path
                  read_only  = volume_mount.value.read_only
                }
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
            }

            dynamic "volume" {
              for_each = var.claims
              content {
                name = volume.value.name
                persistent_volume_claim {
                  claim_name = volume.value.claim_name
                }
              }
            }
          }
        }
      }
    }

    successful_jobs_history_limit = var.successful_jobs_history_limit
    failed_jobs_history_limit     = var.failed_jobs_history_limit
    concurrency_policy            = var.concurrency_policy
    starting_deadline_seconds     = var.starting_deadline_seconds
  }
}
