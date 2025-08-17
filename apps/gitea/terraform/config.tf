# ConfigMap for Gitea configuration
resource "kubernetes_config_map" "gitea" {
  metadata {
    name      = "gitea-config"
    namespace = var.namespace
  }

  data = {
    "app.ini" = <<-EOF
      APP_NAME = Gitea: Git with a cup of tea
      RUN_MODE = prod
      RUN_USER = git

      [repository]
      ROOT = /data/git/repositories

      [repository.local]
      LOCAL_COPY_PATH = /data/gitea/tmp/local-repo

      [repository.upload]
      TEMP_PATH = /data/gitea/uploads

      [server]
      APP_DATA_PATH    = /data/gitea
      DOMAIN           = ${local.app_url}
      SSH_DOMAIN       = ${local.app_url}
      HTTP_PORT        = ${var.http_port}
      ROOT_URL         = https://${local.app_url}/
      DISABLE_SSH      = false
      SSH_PORT         = 22
      SSH_LISTEN_PORT  = ${var.ssh_port}
      LFS_START_SERVER = true
      LFS_CONTENT_PATH = /data/git/lfs
      OFFLINE_MODE     = false

      [database]
      PATH     = /data/gitea/gitea.db
      DB_TYPE  = postgres
      HOST     = postgres.postgres:5432
      NAME     = gitea
      USER     = ugitea
      PASSWD   =
      LOG_SQL  = false
      SCHEMA   =
      SSL_MODE = disable
      CHARSET  = utf8

      [indexer]
      ISSUE_INDEXER_PATH = /data/gitea/indexers/issues.bleve

      [session]
      PROVIDER_CONFIG = /data/gitea/sessions
      PROVIDER        = file

      [picture]
      AVATAR_UPLOAD_PATH      = /data/gitea/avatars
      REPOSITORY_AVATAR_UPLOAD_PATH = /data/gitea/repo-avatars

      [attachment]
      PATH = /data/gitea/attachments

      [log]
      MODE      = console
      LEVEL     = info
      ROOT_PATH = /data/gitea/log

      [security]
      INSTALL_LOCK   = true
      SECRET_KEY     =
      REVERSE_PROXY_LIMIT = 1
      REVERSE_PROXY_TRUSTED_PROXIES = *

      [service]
      DISABLE_REGISTRATION              = false
      ALLOW_ONLY_EXTERNAL_REGISTRATION  = false
      REGISTER_EMAIL_CONFIRM            = false
      ENABLE_NOTIFY_MAIL                = false
      REQUIRE_SIGNIN_VIEW               = false
      DEFAULT_KEEP_EMAIL_PRIVATE        = false
      DEFAULT_ALLOW_CREATE_ORGANIZATION = true
      DEFAULT_ENABLE_TIMETRACKING       = true
      NO_REPLY_ADDRESS                  = noreply.${module.globals.domain}

      [mailer]
      ENABLED = false

      [openid]
      ENABLE_OPENID_SIGNIN = true
      ENABLE_OPENID_SIGNUP = true

      [oauth2_client]
      REGISTER_EMAIL_CONFIRM = false
      OPENID_CONNECT_SCOPES = email profile
      ENABLE_AUTO_REGISTRATION = true

      [actions]
      ENABLED = true
      DEFAULT_ACTIONS_URL = https://${local.app_url}/
    EOF
  }
}