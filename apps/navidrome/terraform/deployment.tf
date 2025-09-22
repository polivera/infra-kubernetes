# apps/navidrome/terraform/navidrome.tf

module "navidrome_deployment" {
  source          = "../../../modules/deployment"
  app_name        = "navidrome"
  namespace       = var.namespace
  image           = var.image
  http_probe      = "/"
  http_probe_port = var.port
  ports = [
    {
      name     = "http"
      port     = var.port
      protocol = "TCP"
    }
  ]
  envs = {
    ND_ENABLELYRICS  = {
      value = "true"
    },
    ND_LYRICSSOURCES  = {
      value = "embedded,lrc,txt"
    },
    ND_MUSICFOLDER  = {
      value = "/music"
    },
    ND_DATAFOLDER  = {
      value = "/data"
    },
    ND_PORT  = {
      value = tostring(var.port)
    },
    ND_LOGLEVEL  = {
      value = var.log_level
    },
    ND_SCANSCHEDULE  = {
      value = var.scan_schedule
    },
    ND_TRANSCODINGCACHESIZE  = {
      value = var.transcoding_cache_size
    },
    ND_SESSIONTIMEOUT  = {
      value = var.session_timeout
    },
    ND_BASEURL  = {
      value = "https://${local.app_url}"
    },
    ND_ENABLETRANSCODINGCONFIG  = {
      value = "true"
    },
    ND_ENABLEDOWNLOADS  = {
      value = tostring(var.enable_downloads)
    },
    ND_ENABLEFAVOURITES  = {
      value = "true"
    },
    ND_ENABLESTARRATING  = {
      value = "true"
    },
    ND_COVERARTPRIORITY  = {
      value = "embedded, cover.*, folder."
    },
    ND_ENABLEEXTERNALSERVICES  = {
      value = tostring(var.enable_external_services)
    }
  }
  mounts = [
    {
      name = "navidrome-data"
      mount_path = "/data"
      read_only = false
    },
    {
      name = "navidrome-music"
      mount_path = "/music"
      read_only = true
    }
  ]
  claims = [
    {
      name = "navidrome-data"
      claim_name = module.navidrome_data_storage.pvc_name
    },
    {
      name = "navidrome-music"
      claim_name = module.navidrome_music_storage.pvc_name
    }
  ]

  depends_on = [
    module.navidrome_data_storage,
    module.navidrome_music_storage
  ]
}
