defmodule Alpa do
  @moduledoc """
  api wrapper for alpaca.markets

  calls return:

  {:ok, result} on success

  {:error, reason} on failure

  https://docs.alpaca.markets/api-documentation/api-v2/
  """
  @endpoint_paper Application.get_env(:alpa, :endpoint_paper) |> to_string()
  @endpoint_data  Application.get_env(:alpa, :endpoint_data)  |> to_string()

  require Jason

  @doc """
  gets account info
  """
  def account do
    get(@endpoint_paper,"/v2/account")
  end

  @doc """
  places an order
  """
  def place_order(symbol, qty, side, type, time_in_force, limit_price \\ nil, stop_price \\ nil) do
    body = Jason.encode!(%{
      symbol: symbol,
      qty: qty,
      side: side,
      type: type,
      time_in_force: time_in_force,
      limit_price: limit_price,
      stop_price: stop_price})
    post(@endpoint_paper, "/v2/orders", body)
  end

  @doc """
  buy day market order wrapper
  """
  def buy(symbol, qty) do
    place_order(symbol, qty, "buy", "market", "day")
  end

  @doc """
  sell day market order wrapper
  """
  def sell(symbol, qty) do
    place_order(symbol, qty, "sell", "market", "day")
  end

  @doc """
  delete an order
  """
  def delete_order(id) do
    delete(@endpoint_paper, "/v2/orders/#{id}")
  end

  @doc """
  delete all orders
  """
  def delete_all_orders do
    delete(@endpoint_paper, "/v2/orders")
  end

  @doc """
  list assets
  """
  def assets do
    get(@endpoint_paper, "/v2/assets")
  end

  @doc """
  get asset by id or symbol
  """
  def asset(id) do
    get(@endpoint_paper, "/v2/assets/#{id}")
  end

  @doc """
  list open positions
  """
  def positions do
    get(@endpoint_paper, "/v2/positions")
  end

  @doc """
  get asset by id or symbol
  """
  def position(id_or_symbol) do
    get(@endpoint_paper, "/v2/positions/#{id_or_symbol}")
  end

  @doc """
  close all positions
  """
  def close_positions do
    delete(@endpoint_paper, "/v2/positions")
  end

  @doc """
  close a position by symbol
  """
  def close_position(symbol) do
    delete(@endpoint_paper, "/v2/positions/$#{symbol}")
  end

  @doc """
  list watchlists
  """
  def watchlists do
    get(@endpoint_paper, "/v2/watchlists")
  end

  @doc """
  get watchlists by id
  """
  def watchlist(id) do
    get(@endpoint_paper, "/v2/watchlists/#{id}")
  end

  @doc """
  delete a watchlist by id
  """
  def delete_watchlist(id) do
    delete(@endpoint_paper, "/v2/watchlists/#{id}")
  end

  @doc """
  create a watchlist
  """
  def create_watchlist(name, symbols \\ []) do
    body = Jason.encode!(%{name: name, symbols: symbols})
    post(@endpoint_paper, "/v2/watchlists", body)
  end

  @doc """
  add an asset to a watchlist
  """
  def watchlist_add_asset(id, symbol) do
    body = Jason.encode!(%{symbol: symbol})
    post(@endpoint_paper, "/v2/watchlists/#{id}", body)
  end

  @doc """
  gets id of watchlist by name

  returns:

  {:ok, id} on success

  {:error, reason} on failure

  """
  def watchlist_id_by_name(name) do
    case watchlists() do
      {:ok, watchlists} ->
        result = watchlists
          |> Enum.find(fn w -> w["name"] == name end)
        case result do
            %{} -> {:ok, Map.fetch!(result, "id")}
            nil -> {:error, "No watchlist named #{name}"}
        end
      {:error, reason} ->
        reason
    end
  end

  @doc """
  get portfolio history
  """
  def history(period \\ "1M", timeframe \\ "1D", date_end \\ Date.utc_today, extended_hours \\ false) do
    get(@endpoint_paper,"/v2/account/portfolio/history?period=#{period}&timeframe=#{timeframe}&date_end=#{date_end}&extended_hour=#{extended_hours}")
  end

  @doc """
  list bars

  paper money account, IEX data only

  (uses 'v1')

  https://docs.alpaca.markets/api-documentation/api-v2/market-data/bars/

  Retrieves a list of bars for each requested symbol. It is guaranteed all bars are in ascending order by time.

  for alpaca api, timestamps are ISO 8601 ('2019-04-15T09:30:00-04:00')

  for Alpa, timestamps are Elixir DateTimes

  params:   alpaca api type/Elixir type
  - timeframe: string, default = "1Min" ["minute", "1Min", "5Min", "15Min", "day" or "1D"]
  - symbols: string, (comma separated list)
  - limit : int, default = 100  (1000 max)
  - start_time : timestamp,  (cannot be used with :after)
  - end_time   : timestamp,  (cannot be used with :until)
  - after : timestamp, (cannot be used with :start)
  - until : timestamp, (cannot be used with :until)

  note: :end, :after, :until  -> :*_time due to Elixir keyword conflict

  returns Bars response  (list of symbol with lists of bar objects)

  ```
  %{:ok,
    [
      %{symbol: "AAPL",
        [
        %{t: 1544129220,
          o: 172.26,
          h: 172.3,
          l: 172.16,
          c: 172.18,
          v: 3892,
          }
        ]
      }
    ]
  }
  ```

  - t : the beginning time of this bar as a Unix epoch in seconds, int
  - o : open price, float
  - h : high price, float
  - l : low price, float
  - c : close price, float
  - v : volume, int
  """
  def bars( %{timeframe: timeframe,
              symbols: symbols,
              limit: limit,
              start_time: start_time,
              end_time: end_time,
              after_time: after_time,
              until_time: until_time}) do
    csv_symbols = Enum.join(symbols, ",")
    get(@endpoint_data,"/v1/bars/#{timeframe}?symbols=#{csv_symbols}&limit=#{limit}&start=#{start_time}&end=#{end_time}&after=#{after_time}&until=#{until_time}")
  end

  defp get(endpoint, path) do
    url = "#{endpoint}#{path}"
    IO.puts url
    HTTPoison.get(url, headers())
      |> handle_response
  end

  defp post(endpoint, path, params) do
    url = "#{endpoint}#{path}"
    HTTPoison.post(url, params, headers())
      |> handle_response
  end

  defp delete(endpoint, path) do
    url = "#{endpoint}#{path}"
    HTTPoison.delete(url, headers())
      |> handle_response
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode! body}
      {:ok, %HTTPoison.Response{status_code: 204}} ->   # delete success
        {:ok, :success}
      {:ok, %HTTPoison.Response{status_code: 207}} ->   # multipart success
        {:ok, :success}
      {:ok, %HTTPoison.Response{status_code: 403, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  auth headers for api
  """
  def headers do
    [
      "APCA-API-KEY-ID": Application.get_env(:alpa, :key),
      "APCA-API-SECRET-KEY": Application.get_env(:alpa, :secret)
    ]
  end

end

