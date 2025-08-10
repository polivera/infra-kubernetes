module "docmost_ingress" {
  source = "../../../modules/ingress"
  cert_secret = module.globals.cert_secret_name
  external_name = "docmost.docmost.svc.cluster.local"
  hostname = local.app_url
  ingress_name = "docmost-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port = var.port

  depends_on = [
    kubernetes_deployment.docmost
  ]
}