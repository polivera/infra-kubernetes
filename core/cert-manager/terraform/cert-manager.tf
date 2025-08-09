# Install cert-manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.17.2"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]

  # DNS configuration using values block
  values = [
    yamlencode({
      podDnsPolicy = "None"
      podDnsConfig = {
        nameservers = [var.cluster_dns, var.external_dns]
        searches = [
          "cert-manager.svc.cluster.local",
          "svc.cluster.local",
          "cluster.local"
        ]
        options = [
          {
            name  = "ndots"
            value = "2"
          },
          {
            name = "edns0"
          }
        ]
      }
      # Use external DNS for propagation checks
      extraArgs = [
        "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53",
        "--dns01-recursive-nameservers-only",
        "--v=4" # Add verbose logging
      ]
    })
  ]

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubectl_manifest" "letsencrypt_clusterissuer" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-cloudflare"
    }
    spec = {
      acme = {
        server = var.acme_server
        email  = local.secrets.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-cloudflare"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = "cloudflare-api-token"
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  })

  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.cloudflare_api_token
  ]
}

resource "kubectl_manifest" "wildcard_certificate" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "vicugna-party-wildcard"
      namespace = kubernetes_namespace.cert_ingress.metadata[0].name
    }
    spec = {
      secretName = module.globals.cert_secret_name
      issuerRef = {
        name = var.cluster_issuer_name
        kind = "ClusterIssuer"
      }
      dnsNames = var.dns_names
    }
  })

  depends_on = [kubectl_manifest.letsencrypt_clusterissuer]
}
