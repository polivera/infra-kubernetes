variable "cert_namespace" {
  description = "Namespace where cert-manager and certificates are deployed"
  type        = string
  default     = "cert-ingress"
}

variable "acme_server" {
  description = "ACME server URL"
  type        = string
  #default     = "https://acme-v02.api.letsencrypt.org/directory"
  # Use this for testing:
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "dns_names" {
  description = "DNS names for wildcard certificate"
  type        = list(string)
  default     = ["*.vicugna.party", "vicugna.party"]
}

variable "cluster_issuer_name" {
  description = "Name of the ClusterIssuer"
  type        = string
  default     = "letsencrypt-cloudflare"
}

variable "certificate_name" {
  description = "Name of the Certificate resource"
  type        = string
  default     = "vicugna-party-wildcard"
}

variable "certificate_secret_name" {
  description = "Name of the TLS secret containing the certificate"
  type        = string
  default     = "vicugna-party-wildcard-tls"
}

variable "cloudflare_secret_name" {
  description = "Name of the secret containing Cloudflare API token"
  type        = string
  default     = "cloudflare-api-token"
}
