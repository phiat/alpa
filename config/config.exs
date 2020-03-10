use Mix.Config
require Logger

config :alpa,
  key: System.get_env("APCA_API_KEY"),
  secret: System.get_env("APCA_API_SECRET"),
  endpoint_paper: System.get_env("APCA_API_PAPER"),
  endpoint_data: System.get_env("APCA_API_DATA")

config :alpa, author: "phiat"
