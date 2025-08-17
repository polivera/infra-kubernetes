# apps/audiobookshelf/terraform/service.tf
# Service for AudioBookshelf
module "audiobookshelf_service" {
  source      = "../../../modules/services"
  name        = "audiobookshelf"
  namespace   = var.namespace
  headless    = true
  port        = var.port
  target_port = var.port
}