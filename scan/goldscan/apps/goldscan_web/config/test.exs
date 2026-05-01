import Config

config :goldscan_web, :sql_sandbox, true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :goldscan_web, GoldScanWeb.Endpoint,
  http: [port: 4002],
  secret_key_base: "27Swe6KtEtmN37WyEYRjKWyxYULNtrxlkCEKur4qoV+Lwtk8lafsR16ifz1XBBYj",
  server: true,
  pubsub_server: GoldScanWeb.PubSub,
  checksum_address_hashes: true

config :goldscan_web, GoldScanWeb.Tracer, disabled?: false

config :logger, :goldscan_web, path: Path.absname("logs/test/goldscan_web.log")

# Configure wallaby
config :wallaby, screenshot_on_failure: true, driver: Wallaby.Chrome, js_errors: false

config :goldscan_web, GoldScanWeb.Counters.BlocksIndexedCounter, enabled: false

config :goldscan_web, GoldScanWeb.Counters.InternalTransactionsIndexedCounter, enabled: false

config :oauth2, adapter: Explorer.Mock.TeslaAdapter

config :tesla, adapter: Explorer.Mock.TeslaAdapter

config :ueberauth, Ueberauth,
  providers: [
    auth0: {
      Ueberauth.Strategy.Auth0,
      [callback_url: "example.com/callback"]
    }
  ]
