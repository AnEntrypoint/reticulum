use Mix.Config

# NOTE: this file contains some security keys/certs that are *not* secrets, and are only used for local development purposes.

host = "hubs.local"
cors_proxy_host = "hubs-proxy.local"

# To run reticulum across a LAN for local testing, uncomment and change the line below to the LAN IP
# host = "192.168.1.27"

dev_janus_host = "dev-janus.reticulum.io"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ret, RetWeb.Endpoint,
  url: [scheme: "https", host: host, port: 4000],
  static_url: [scheme: "https", host: host, port: 4000],
  https: [
    port: 4000,
    otp_app: :ret,
    cipher_suite: :strong,
    keyfile: "#{System.get_env("PWD")}/priv/dev-ssl.key",
    certfile: "#{System.get_env("PWD")}/priv/dev-ssl.cert"
  ],
  cors_proxy_url: [scheme: "https", host: cors_proxy_host, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "txlMOtlaY5x3crvOCko4uV5PM29ul3zGo1oBGNO3cDXx+7GHLKqt0gR9qzgThxb5",
  allowed_origins: "*",
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :ret, RetWeb.Endpoint,
  # static_url: [scheme: "https", host: "assets-prod.reticulum.io", port: 443],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/ret_web/views/.*(ex)$},
      ~r{lib/ret_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

env_db_host = "#{System.get_env("DB_HOST")}"

# Configure your database
config :ret, Ret.Repo,
  username: "postgres",
  password: "postgres",
  database: "ret_dev",
  hostname: if(env_db_host == "", do: "localhost", else: env_db_host),
  template: "template0",
  pool_size: 10

config :ret, RetWeb.Plugs.HeaderAuthorization,
  header_name: "x-ret-admin-access-key",
  header_value: "admin-only"

config :ret, Ret.DiscordClient,
  client_id: "",
  client_secret: "",
  bot_token: ""

# Allow any origin for API access in dev
config :cors_plug, origin: ["*"]

config :ret,
  upload_encryption_key: "a8dedeb57adafa7821027d546f016efef5a501bd",
  bot_access_key: ""

config :ret, Ret.PageOriginWarmer,
  hubs_page_origin: "https://#{host}:8080",
  admin_page_origin: "https://#{host}:8989",
  spoke_page_origin: "https://#{host}:9090",
  insecure_ssl: true

config :ret, Ret.HttpUtils, insecure_ssl: true

config :ret, Ret.MediaResolver,
  giphy_api_key: nil,
  deviantart_client_id: nil,
  deviantart_client_secret: nil,
  imgur_mashape_api_key: nil,
  imgur_client_id: nil,
  google_poly_api_key: nil,
  youtube_api_key: nil,
  sketchfab_api_key: nil,
  ytdl_host: nil,
  photomnemonic_endpoint: "https://uvnsm9nzhe.execute-api.us-west-1.amazonaws.com/public"

config :ret, Ret.Speelycaptor, speelycaptor_endpoint: "https://1dhaogh2hd.execute-api.us-west-1.amazonaws.com/public"

config :ret, Ret.Storage,
  storage_path: "storage/dev",
  ttl: 60 * 60 * 24

asset_hosts =
  "https://localhost:4000 https://localhost:8080 " <>
    "https://#{host}:4000 https://#{host}:8080 https://#{host}:3000 https://#{host}:8989 https://#{host}:9090 https://#{
      cors_proxy_host
    }:4000 " <>
    "https://assets-prod.reticulum.io https://asset-bundles-dev.reticulum.io https://asset-bundles-prod.reticulum.io"

websocket_hosts =
  "https://localhost:4000 https://localhost:8080 wss://localhost:4000 " <>
    "https://#{host}:4000 https://#{host}:8080 wss://#{host}:4000 wss://#{host}:8080 wss://#{host}:8989 wss://#{host}:9090 " <>
    "wss://#{dev_janus_host} wss://prod-janus.reticulum.io wss://#{host}:4000 wss://#{host}:8080 https://#{host}:8080 https://hubs.local:8080 wss://hubs.local:8080"

script_shas =
  "'sha256-hsbRcgUBASABDq7qVGVTpbnWq/ns7B+ToTctZFJXYi8=' 'sha256-MIpWPgYj31kCgSUFc0UwHGQrV87W6N5ozotqfxxQG0w=' 'sha256-/S6PM16MxkmUT7zJN2lkEKFgvXR7yL4Z8PCrRrFu4Q8='"

config :ret, RetWeb.Plugs.AddCSP,
  content_security_policy:
    "default-src 'none'; script-src 'self' #{script_shas} #{asset_hosts} https://cdn.rawgit.com https://aframe.io https://www.google-analytics.com 'unsafe-eval'; worker-src 'self' blob:; font-src 'self' https://fonts.googleapis.com https://fonts.gstatic.com https://cdn.aframe.io #{
      asset_hosts
    }; style-src 'self' https://fonts.googleapis.com https://cdn.jsdelivr.net #{asset_hosts} 'unsafe-inline'; connect-src 'self' https://#{
      host
    }:8080 https://sentry.prod.mozaws.net https://dpdb.webvr.rocks #{asset_hosts} #{websocket_hosts} https://cdn.aframe.io https://www.mozilla.org data: blob:; img-src 'self' #{
      asset_hosts
    } https://cdn.aframe.io https://cdn.jsdelivr.net data: blob:; media-src 'self' #{asset_hosts} data: blob:; frame-src 'self'; base-uri 'none'; form-action 'self'; manifest-src 'self' #{
      asset_hosts
    };"

config :ret, Ret.Mailer, adapter: Bamboo.LocalAdapter

config :ret, RetWeb.Email, from: "info@hubs-mail.com"

config :ret, Ret.PermsToken, perms_key: (System.get_env("PERMS_KEY") || "") |> String.replace("\\n", "\n")

config :ret, Ret.OAuthToken, oauth_token_key: ""

config :ret, Ret.Guardian,
  issuer: "ret",
  secret_key: "47iqPEdWcfE7xRnyaxKDLt9OGEtkQG3SycHBEMOuT2qARmoESnhc76IgCUjaQIwX",
  ttl: {12, :weeks}

config :web_push_encryption, :vapid_details,
  subject: "mailto:admin@mozilla.com",
  public_key: "BAb03820kHYuqIvtP6QuCKZRshvv_zp5eDtqkuwCUAxASBZMQbFZXzv8kjYOuLGF16A3k8qYnIN10_4asB-Aw7w",
  private_key: "w76tXh1d3RBdVQ5eINevXRwW6Ow6uRcBa8tBDOXfmxM"

config :sentry,
  environment_name: :dev,
  json_library: Poison,
  included_environments: [],
  tags: %{
    env: "dev"
  }

config :ret, Ret.Habitat, ip: "127.0.0.1", http_port: 9631

config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 443

config :ret, Ret.RoomAssigner, balancer_weights: [{600, 1}, {300, 50}, {0, 500}]

config :ret, RetWeb.PageController, skip_cache: true

config :ret, Ret.HttpUtils, insecure_ssl: true

config :ret, Ret.Locking, lock_timeout_ms: 1000 * 60 * 15
config :ret, Ret.Repo.Migrations.AdminSchemaInit, postgrest_password: "password"
