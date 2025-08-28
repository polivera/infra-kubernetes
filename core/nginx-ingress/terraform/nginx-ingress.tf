# Install NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },

    {
      name  = "controller.service.loadBalancerIP"
      value = var.ingress_load_balancer_ip
    },

    {
      name  = "controller.service.annotations.metallb\\.universe\\.tf/address-pool"
      value = var.metallb_pool
    },

    # Enable SSL redirect by default
    {
      name  = "controller.config.ssl-redirect"
      value = var.ssl_redirect
    },

    # Configure for better performance
    {
      name  = "controller.config.use-forwarded-headers"
      value = var.forward_headers
    },

    {
      name  = "controller.config.compute-full-forwarded-for"
      value = var.full_forwarded_for
    },

    # Global timeout settings for file uploads
    {
      name  = "controller.config.proxy-connect-timeout"
      value = var.proxy_connect_timeout
    },

    {
      name  = "controller.config.proxy-send-timeout"
      value = var.proxy_send_timeout
    },

    {
      name  = "controller.config.proxy-read-timeout"
      value = var.proxy_read_timeout
    },

    {
      name  = "controller.config.proxy-body-size"
      value = var.proxy_body_size
    },

    # Resource limits
    {
      name  = "controller.resources.requests.cpu"
      value = var.request_cpu
    },

    {
      name  = "controller.resources.requests.memory"
      value = var.request_memory
    },

    {
      name  = "controller.resources.limits.cpu"
      value = var.limit_cpu
    },

    {
      name  = "controller.resources.limits.memory"
      value = var.limit_memory
    }
  ]

  depends_on = [kubernetes_namespace.ingress_nginx]
}
