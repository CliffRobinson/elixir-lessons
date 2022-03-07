import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_memory, PhoenixMemoryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Oph9nLofJ4YhHAjzmVtKoyeeeyu5s4q8jhLJO8CFR5f3Lf8MnReNhHhLngeEy7MH",
  server: false

# In test we don't send emails.
config :phoenix_memory, PhoenixMemory.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
