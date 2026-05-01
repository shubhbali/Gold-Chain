# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

[__DIR__ | ~w(.. .. .. config config_helper.exs)]
|> Path.join()
|> Code.eval_file()

# General application configuration
config :goldscan_web,
  namespace: GoldScanWeb,
  ecto_repos: ConfigHelper.repos(),
  cookie_domain: System.get_env("SESSION_COOKIE_DOMAIN"),
  # 604800 seconds, 1 week
  session_cookie_ttl: 60 * 60 * 24 * 7,
  invalid_session_key: "invalid_session",
  api_v2_temp_token_cookie_key: "api_v2_temp_token",
  api_v2_temp_token_header_key: "api-v2-temp-token",
  http_client: Explorer.HttpClient.Tesla

config :goldscan_web,
  admin_panel_enabled: ConfigHelper.parse_bool_env_var("ADMIN_PANEL_ENABLED")

config :goldscan_web,
  disable_api?: ConfigHelper.parse_bool_env_var("DISABLE_API")

config :goldscan_web, GoldScanWeb.Counters.BlocksIndexedCounter, enabled: true

config :goldscan_web, GoldScanWeb.Counters.InternalTransactionsIndexedCounter, enabled: true

config :goldscan_web, GoldScanWeb.Tracer,
  service: :goldscan_web,
  adapter: SpandexDatadog.Adapter,
  trace_key: :goldscan

# Configures gettext
config :goldscan_web, GoldScanWeb.Gettext, locales: ~w(en), default_locale: "en"

config :goldscan_web, GoldScanWeb.SocialMedia,
  twitter: "PoaNetwork",
  telegram: "poa_network",
  facebook: "PoaNetwork",
  instagram: "PoaNetwork"

config :goldscan_web, GoldScanWeb.Chain.TransactionHistoryChartController,
  # days
  history_size: 30

config :logger, :goldscan_web,
  metadata: ConfigHelper.logger_metadata(),
  metadata_filter: [application: :goldscan_web]

config :ex_cldr,
  default_locale: "en",
  default_backend: GoldScanWeb.Cldr

config :prometheus, GoldScanWeb.Prometheus.PublicExporter,
  path: "/public-metrics",
  format: :auto,
  registry: :public,
  auth: false

config :spandex_phoenix, tracer: GoldScanWeb.Tracer

config :goldscan_web, GoldScanWeb.Routers.ApiRouter,
  writing_enabled: !ConfigHelper.parse_bool_env_var("API_V1_WRITE_METHODS_DISABLED"),
  reading_enabled: !ConfigHelper.parse_bool_env_var("API_V1_READ_METHODS_DISABLED")

config :goldscan_web, GoldScanWeb.Routers.WebRouter,
  enabled: !ConfigHelper.parse_bool_env_var("DISABLE_WEBAPP", "true")

config :goldscan_web, GoldScanWeb.CSPHeader,
  mixpanel_url: ConfigHelper.parse_url_env_var("MIXPANEL_URL", "https://api-js.mixpanel.com"),
  amplitude_url: ConfigHelper.parse_url_env_var("AMPLITUDE_URL", "https://api2.amplitude.com/2/httpapi")

config :goldscan_web, Api.GraphQL,
  enabled: ConfigHelper.parse_bool_env_var("API_GRAPHQL_ENABLED", "true"),
  token_limit: ConfigHelper.parse_integer_env_var("API_GRAPHQL_TOKEN_LIMIT", 1000),
  max_complexity: ConfigHelper.parse_integer_env_var("API_GRAPHQL_MAX_COMPLEXITY", 100)

# Configures Ueberauth local settings
config :ueberauth, Ueberauth,
  providers: [
    auth0: {
      Ueberauth.Strategy.Auth0,
      [callback_path: "/auth/auth0/callback", callback_params: ["path"]]
    }
  ]

config :oauth2, adapter: Tesla.Adapter.Mint

config :tesla, adapter: Tesla.Adapter.Mint

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
