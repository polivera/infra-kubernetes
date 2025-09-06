module "mongodb_storage" {
  source     = "../../../../../modules/static-nfs-volume"
  app_name   = "${data.kubernetes_namespace.mongodb.metadata[0].name}-mongodb"
  namespace  = data.kubernetes_namespace.mongodb.metadata[0].name
  size       = var.mongodb_request_storage
  pool       = "fast"
  force_path = "Flipflow/mongo"
}
