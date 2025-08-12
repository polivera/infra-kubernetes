resource "kubernetes_config_map" "paperless" {
  metadata {
    name      = "paperless-config"
    namespace = var.namespace
  }

  data = {
    # Basic configuration
    PAPERLESS_URL           = "https://${local.app_url}"
    PAPERLESS_PORT          = tostring(var.port)
    PAPERLESS_TIME_ZONE     = var.paperless_time_zone
    PAPERLESS_OCR_LANGUAGE  = "eng+spa"
    PAPERLESS_OCR_LANGUAGES = var.ocr_languages

    # Security settings
    PAPERLESS_FORCE_SCRIPT_NAME = "/paperless"
    PAPERLESS_STATIC_URL        = "/paperless/static/"

    # Document processing
    PAPERLESS_CONSUMER_POLLING           = "0"
    PAPERLESS_CONSUMER_DELETE_DUPLICATES = "false"
    PAPERLESS_CONSUMER_RECURSIVE         = "false"
    PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS   = "false"

    # OCR settings
    PAPERLESS_OCR_MODE                   = "skip"
    PAPERLESS_OCR_SKIP_ARCHIVE_FILE      = "with_text"
    PAPERLESS_OCR_DESKEW                 = "true"
    PAPERLESS_OCR_ROTATE_PAGES           = "true"
    PAPERLESS_OCR_ROTATE_PAGES_THRESHOLD = "12.0"

    # Tika settings for document parsing
    PAPERLESS_TIKA_ENABLED            = "false"
    PAPERLESS_TIKA_ENDPOINT           = "http://tika:9998"
    PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://gotenberg:3000"

    # Threading and performance
    PAPERLESS_TASK_WORKERS       = "2"
    PAPERLESS_THREADS_PER_WORKER = "1"
    PAPERLESS_WORKER_TIMEOUT     = "1800"

    # File handling
    PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{title}"
    PAPERLESS_LOGGING_DIR     = "/usr/src/paperless/data/log"

    # UI settings
    PAPERLESS_AUTO_LOGIN_USERNAME     = ""
    PAPERLESS_COOKIE_PREFIX           = "paperless_"
    PAPERLESS_ENABLE_HTTP_REMOTE_USER = "false"
  }
}
