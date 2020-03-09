use Mix.Config
require Logger

config :alpa,
  api: System.get_env("ALPACA_API"),
  key: System.get_env("APCA_API_KEY"),
  secret: System.get_env("APCA_API_SECRET")

config :alpa, author: "phiat"
