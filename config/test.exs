import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :currency_conversor, CurrencyConversorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "trbQd6SuMi/1gccMJpb64CdFgM6WaTkT+1bOxTIhkYnDv+FK/VFpJj+pu0UqPH0b",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :tesla, adapter: Tesla.Mock

config :currency_conversor, CurrencyConversor.FixerConversor, api_key: "some-key"
