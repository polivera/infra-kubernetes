# Kubernetes Home Lab Infrastructure

A production-grade Kubernetes infrastructure project managing a personal K3s cluster using Infrastructure as Code principles. This repository demonstrates enterprise-level DevOps practices including modular Terraform design, encrypted secrets management, and automated application deployment patterns.

## Overview

This project provisions and manages a complete home Kubernetes cluster running 25+ applications across media servers, development tools, monitoring solutions, and databases. Built with scalability and maintainability in mind, it showcases modern cloud-native architecture patterns and GitOps workflows.

**Domain**: `vicugna.party` | **Cluster**: K3s on bare metal

## Technical Stack

- **Container Orchestration**: Kubernetes (K3s)
- **Infrastructure as Code**: Terraform with HCL
- **Secrets Management**: Mozilla SOPS with PGP encryption
- **Ingress Controller**: NGINX Ingress Controller
- **TLS Management**: cert-manager with wildcard certificates
- **Load Balancing**: MetalLB
- **Storage**: NFS CSI Driver with persistent volumes
- **Task Automation**: just (command runner)
- **Version Control**: Git with encrypted secrets

## Architecture

### Three-Tier Infrastructure Design

```
┌─────────────────────────────────────────────────────────────┐
│                      APPLICATIONS (apps/)                    │
│  Media • Development • Monitoring • Databases • Utilities    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ↓
┌─────────────────────────────────────────────────────────────┐
│               INFRASTRUCTURE COMPONENTS (core/)              │
│   Ingress • TLS • Load Balancer • Storage • Backups         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              REUSABLE MODULES (modules/)                     │
│  Deployment • StatefulSet • Ingress • Storage • Services     │
└─────────────────────────────────────────────────────────────┘
```

### Key Design Patterns

- **DRY Principle**: Reusable Terraform modules eliminate code duplication
- **Separation of Concerns**: Clear boundaries between infrastructure, core services, and applications
- **Centralized Configuration**: Global settings managed in a single source of truth
- **ExternalName Ingress Pattern**: Apps in their own namespaces with ingress in centralized namespace
- **GitOps Ready**: All configuration versioned and declarative

## Features

### Infrastructure as Code
- 100% declarative Kubernetes resource management
- Modular Terraform architecture for easy maintenance and scaling
- Standardized deployment patterns across all applications

### Security & Secrets
- SOPS encryption for all sensitive data at rest
- PGP key-based encryption with `.sops.yaml` configuration
- No plaintext secrets in version control
- Automated TLS certificate management with Let's Encrypt

### Automation & Developer Experience
- `justfile` commands for consistent workflows
- One-command deployment: `just init/plan/apply`
- Standardized secret encryption/decryption across all apps
- Health probes and resource limits on all deployments

### High Availability & Storage
- NFS-backed persistent volumes for stateful applications
- MetalLB load balancer for service exposure
- Resource requests and limits for proper scheduling
- Node affinity for GPU workloads

## Deployed Applications

### Media Servers
- **Jellyfin**: Media streaming platform
- **Audiobookshelf**: Audiobook and podcast server
- **Kavita**: Digital library and ebook reader
- **Navidrome**: Music server and streamer
- **qBittorrent**: Torrent client with web UI
- **MeTube**: YouTube downloader

### Development & Productivity
- **Gitea**: Self-hosted Git service
- **Docmost**: Documentation and wiki platform
- **Paperless**: Document management system
- **Planka**: Kanban project management
- **Vikunja**: Task and project management
- **SearXNG**: Privacy-respecting metasearch engine

### Infrastructure & Monitoring
- **Monitoring Stack**: Prometheus, Grafana, alerting
- **Home Assistant**: Home automation platform
- **Homarr**: Application dashboard
- **Dashy**: Customizable dashboard
- **Heimdall**: Application launcher

### Databases & Caching
- **PostgreSQL**: Relational database
- **MySQL**: Relational database
- **Redis**: In-memory data store
- **Valkey**: Redis-compatible key-value store

### AI/ML
- **LLM**: Language model inference
- **GPU Operator**: NVIDIA GPU support for Kubernetes

## Repository Structure

```
.
├── modules/                    # Reusable Terraform modules
│   ├── globals/               # Centralized configuration
│   ├── deployment/            # Kubernetes Deployment module
│   ├── statefulset/           # StatefulSet with persistent storage
│   ├── ingress/               # Ingress with ExternalName pattern
│   ├── static-nfs-volume/     # NFS-backed PV/PVC
│   ├── services/              # Kubernetes Service module
│   └── cronjob/               # CronJob module
│
├── core/                      # Infrastructure components
│   ├── cert-manager/          # TLS certificate automation
│   ├── nginx-ingress/         # Ingress controller
│   ├── metallb/               # Load balancer
│   ├── nfs-csi-driver/        # NFS storage provisioner
│   └── backups/               # Backup solutions
│
├── apps/                      # Application deployments
│   ├── <app-name>/
│   │   ├── justfile           # SOPS encrypt/decrypt commands
│   │   ├── secrets.enc.yaml   # Encrypted secrets (committed)
│   │   └── terraform/         # Terraform configuration
│   │       ├── main.tf        # Provider, namespace, globals
│   │       ├── deployment.tf  # App deployment
│   │       ├── service.tf     # Kubernetes service
│   │       ├── ingress.tf     # Ingress configuration
│   │       ├── storage.tf     # Persistent volumes
│   │       └── secrets.tf     # SOPS integration
│   └── ...
│
├── justfile                   # Root task automation
├── .sops.yaml                 # SOPS configuration
└── CLAUDE.md                  # Development documentation
```

## Infrastructure Components

### Core Services

#### cert-manager
Automates TLS certificate provisioning and renewal using Let's Encrypt. Manages a wildcard certificate for `*.vicugna.party` used across all ingress resources.

#### NGINX Ingress Controller
Routes external HTTP/HTTPS traffic to services. Deployed in `cert-ingress` namespace with custom timeout and body size configurations for media streaming.

#### MetalLB
Provides LoadBalancer service type support for bare metal Kubernetes. Assigns IPs from a configured pool for external access.

#### NFS CSI Driver
Enables dynamic and static provisioning of NFS-backed persistent volumes. All stateful applications use NFS storage from `192.168.0.11`.

### Global Configuration

Centralized in `modules/globals/main.tf`:
- **Domain**: `vicugna.party`
- **Cluster DNS**: `10.43.0.10` (K3s kube-dns)
- **NFS Server**: `192.168.0.11`
- **Timezone**: `Europe/Madrid`
- **TLS Secret**: `vicugna-party-wildcard-tls`

## Getting Started

### Prerequisites

- Terraform >= 1.0
- kubectl configured with cluster access
- just command runner
- SOPS with PGP key configured

### Deployment Workflow

#### 1. Deploy Core Infrastructure (one-time)

```bash
# Deploy in order
just init core/metallb/terraform && just apply core/metallb/terraform
just init core/nfs-csi-driver/terraform && just apply core/nfs-csi-driver/terraform
just init core/nginx-ingress/terraform && just apply core/nginx-ingress/terraform
just init core/cert-manager/terraform && just apply core/cert-manager/terraform
```

#### 2. Deploy an Application

```bash
# List all modules
just list

# Deploy workflow
just init apps/<app-name>/terraform
just plan apps/<app-name>/terraform
just apply apps/<app-name>/terraform
```

#### 3. Managing Secrets

```bash
# From app directory with justfile
cd apps/<app-name>

# Edit encrypted secrets
just decrypt
# Edit secrets.yaml
just encrypt

# Or use sops directly
sops secrets.enc.yaml
```

### Common Commands

```bash
# Format all Terraform files
just fmt

# Destroy an application
just destroy apps/<app-name>/terraform

# View Terraform state
cd apps/<app-name>/terraform
terraform state list
```

## Module Usage Examples

### Standard Deployment

```hcl
module "app_deployment" {
  source = "../../../modules/deployment"

  namespace      = var.namespace
  app_name       = var.namespace
  image          = "ghcr.io/owner/image:tag"

  # Resources
  request_cpu    = "100m"
  request_memory = "256Mi"
  limit_cpu      = "1000m"
  limit_memory   = "1Gi"

  # Environment
  envs = {
    TZ = { value = module.globals.tz }
  }

  # Persistent storage
  mounts = [{
    name       = "data"
    mount_path = "/data"
    read_only  = false
  }]
  claims = [{
    name       = "data"
    claim_name = module.storage.pvc_name
  }]

  # Health checks
  http_probe      = "/health"
  http_probe_port = 8080
}
```

### Ingress with TLS

```hcl
module "ingress" {
  source = "../../../modules/ingress"

  ingress_name      = var.namespace
  ingress_namespace = module.globals.ingress_namespace
  hostname          = "${var.namespace}.${module.globals.domain}"
  external_name     = "${var.namespace}.${var.namespace}.svc.cluster.local"
  port              = 8080

  tls_secret_name = module.globals.cert_secret_name
}
```

### NFS-Backed Storage

```hcl
module "storage" {
  source = "../../../modules/static-nfs-volume"

  pv_name    = "${var.namespace}-data"
  pvc_name   = "${var.namespace}-data-pvc"
  namespace  = var.namespace
  nfs_server = module.globals.nfs_server
  nfs_path   = "/mnt/storage/kubernetes/${var.namespace}/data"
  capacity   = "100Gi"
}
```

## Technical Highlights

### For Portfolio Reviewers

This project demonstrates:

1. **Enterprise Infrastructure Patterns**: Modular, reusable, and maintainable IaC following HashiCorp best practices
2. **Security Best Practices**: Encrypted secrets management with SOPS, automated TLS, least-privilege patterns
3. **Cloud-Native Architecture**: Kubernetes-native patterns, service discovery, ingress routing, persistent storage
4. **DevOps Automation**: Consistent deployment workflows, infrastructure as code, declarative configuration
5. **System Architecture**: Three-tier separation, centralized configuration, standardized application patterns
6. **Production-Ready**: Health probes, resource limits, monitoring, backup strategies
7. **Documentation**: Comprehensive inline documentation and standardized patterns

### Scaling & Extensibility

Adding a new application requires:
1. Copy application template structure
2. Configure `variables.tf` for the application
3. Encrypt secrets with SOPS
4. Run `just init/plan/apply`

The modular design ensures consistency and reduces deployment time from hours to minutes.

## License

This is a personal infrastructure project. Feel free to use it as inspiration for your own homelab!

## Contact

**Pablo** - Infrastructure Engineer & Cloud Native Enthusiast

---

*Built with Terraform, Kubernetes, and sops*
