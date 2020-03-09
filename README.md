# Alpa

API wrapper for [Alpaca Markets](https://alpaca.markets)

elixir libs: [HTTPoison](https://github.com/edgurgel/httpoison/), [Jason](https://github.com/michalmuskala/jason)  

config

```bash
export ALPACA_API="https://paper-api.alpaca.markets"
export APCA_API_KEY="XXXXXXXXXXXXXXX"
export APCA_API_SECRET="XXXXXXXXXXXXXX"
```

## Usage

### account info

```elixir
iex(1)> Alpa.account
{:ok,
 %{
   "account_blocked" => false,
   "account_number" => "XXXXXXXXXX",
   "buying_power" => "400000",
   "cash" => "100000",
   "created_at" => "2020-03-08T20:34:27.768721Z", 
   "currency" => "USD",
   "daytrade_count" => 0,
   "daytrading_buying_power" => "400000",
   "equity" => "100000",
   "id" => "d905b07d-240c-4c07-9bb5-707820aae345",
   "initial_margin" => "0",
   "last_equity" => "100000",
   "last_maintenance_margin" => "0",
   "long_market_value" => "0",
   "maintenance_margin" => "0",
   "multiplier" => "4",
   "pattern_day_trader" => false,
   "portfolio_value" => "100000",
   "regt_buying_power" => "200000",
   "short_market_value" => "0",
   "shorting_enabled" => true,
   "sma" => "0",
   "status" => "ACTIVE",
   "trade_suspended_by_user" => false,
   "trading_blocked" => false,
   "transfers_blocked" => false
 }}
```

### buy day market order

```elixir
iex(5)> Alpa.buy("AMD",10)
{:ok,
 %{
   "asset_class" => "us_equity",
   "asset_id" => "03fb07bb-5db1-4077-8dea-5d711b272625",
   "canceled_at" => nil,
   "client_order_id" => "9bd7ecf4-5f77-4c97-97a3-77407238d4d7",
   "created_at" => "2020-03-09T01:27:48.111921Z",
   "expired_at" => nil,
   "extended_hours" => false,
   "failed_at" => nil,
   "filled_at" => nil,
   "filled_avg_price" => nil,
   "filled_qty" => "0",
   "id" => "24c8895d-0ecc-43f3-acfc-83ca79785908",
   "legs" => nil,
   "limit_price" => nil,
   "order_class" => "",
   "order_type" => "market",
   "qty" => "10",
   "replaced_at" => nil,
   "replaced_by" => nil,
   "replaces" => nil,
   "side" => "buy",
   "status" => "accepted",
   "stop_price" => nil,
   "submitted_at" => "2020-03-09T01:27:48.074728Z",
   "symbol" => "AMD",
   "time_in_force" => "day",
   "type" => "market",
   "updated_at" => "2020-03-09T01:27:48.111921Z"
 }}
```

### delete a pending order 

```elixir
iex(2)> Alpa.delete_order("a5521a11-e664-44d8-b848-f613ae8c4fcc")
{:ok, :success}
```

### delete all pending orders

```elixir
iex(3)> Alpa.delete_all_orders
{:ok, :success}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `alpa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alpa, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/alpa](https://hexdocs.pm/alpa).

## License 

MIT

made with Elixir and 💙,  by phiat


