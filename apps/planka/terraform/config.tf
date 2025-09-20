resource "kubernetes_config_map" "planka" {
  metadata {
    name      = "planka-config"
    namespace = var.namespace
  }

  data = {
    # Server configuration
    BASE_URL    = "https://${local.app_url}"
    TRUST_PROXY = "0"

    # Database configuration (using existing PostgreSQL)
    DATABASE_URL = "" # Will be overridden by secret

    # File uploads
    ATTACHMENTS_DESTINATION = "local"
    ATTACHMENTS_LOCAL_PATH  = "/app/public/user-content/attachments"

    # Project background images
    PROJECT_BACKGROUND_IMAGES_DESTINATION = "local"
    PROJECT_BACKGROUND_IMAGES_LOCAL_PATH  = "/app/public/user-content/project-background-images"

    # User avatars
    USER_AVATARS_DESTINATION = "local"
    USER_AVATARS_LOCAL_PATH  = "/app/public/user-content/user-avatars"

    # Session configuration
    SESSION_SECRET = "" # Will be overridden by secret

    # Email configuration (optional)
    # EMAIL_FROM = "noreply@vicugna.party"
    # SMTP_HOST = "smtp.gmail.com"
    # SMTP_PORT = "587"
    # SMTP_SECURE = "false"
    # SMTP_USER = "noreply@vicugna.party"
    # SMTP_PASSWORD = "" # Would come from secret if enabled
  }
}