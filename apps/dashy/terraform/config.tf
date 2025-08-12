# apps/dashy/terraform/config.tf
resource "kubernetes_config_map" "dashy" {
  metadata {
    name      = "dashy-config"
    namespace = var.namespace
  }

  data = {
    # Basic Dashy configuration
    "conf.yml" = <<-EOF
      ---
      pageInfo:
        title: Vicugna.party Dashboard
        description: Welcome to your homelab dashboard
        navLinks:
          - title: GitHub
            path: https://github.com
          - title: Proxmox
            path: https://proxmox.vicugna.party
          - title: TrueNAS
            path: https://truenas.vicugna.party

      appConfig:
        theme: colorful
        layout: auto
        iconSize: medium
        language: en
        startingView: default
        defaultOpeningMethod: newtab
        statusCheck: false
        statusCheckInterval: 0
        faviconApi: allesedv
        routingMode: history
        enableMultiTasking: false
        widgetsAlwaysUseProxy: false
        webSearch:
          searchEngine: duckduckgo
          openingMethod: newtab
        enableFontAwesome: true
        enableMaterialDesignIcons: false
        hideComponents:
          hideHeading: false
          hideNav: false
          hideSearch: false
          hideSettings: false
          hideFooter: false

      sections:
        - name: Applications
          icon: fas fa-rocket
          items:
            - title: Docmost
              description: Documentation platform
              icon: fas fa-book
              url: https://docs.vicugna.party
              target: newtab

            - title: Grafana
              description: Monitoring and observability
              icon: fas fa-chart-line
              url: https://grafana.vicugna.party
              target: newtab

            - title: Prometheus
              description: Metrics collection
              icon: fas fa-chart-bar
              url: https://prometheus.vicugna.party
              target: newtab

        - name: Media
          icon: fas fa-play
          items:
            - title: Kavita
              description: Digital library
              icon: fas fa-book-open
              url: https://books.vicugna.party
              target: newtab

            - title: qBittorrent
              description: Torrent client
              icon: fas fa-download
              url: https://torrent.vicugna.party
              target: newtab

        - name: Infrastructure
          icon: fas fa-server
          items:
            - title: Proxmox
              description: Virtualization platform
              icon: fas fa-desktop
              url: https://proxmox.vicugna.party
              target: newtab

            - title: TrueNAS
              description: Network attached storage
              icon: fas fa-hdd
              url: https://truenas.vicugna.party
              target: newtab

            - title: OPNsense
              description: Firewall and router
              icon: fas fa-shield-alt
              url: https://opnsense.vicugna.party
              target: newtab
    EOF
  }
}