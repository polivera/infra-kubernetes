module "mongodb_service" {
  source      = "../../../../../modules/services"
  name        = "mongodb"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.141"
  port        = var.mongodb_external_port
  target_port = var.mongodb_port
}
