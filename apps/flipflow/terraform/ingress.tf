module "druid_ingress" {
  count  = var.enable_druid
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "druid-router.${kubernetes_namespace.flipflow.metadata[0].name}.svc.cluster.local"
  hostname          = local.druid_app_url
  ingress_name      = "druid-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.druid_router_port

  depends_on = [
    kubernetes_deployment.druid_router
  ]
}
