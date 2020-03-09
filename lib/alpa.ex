defmodule Alpa do
  @moduledoc """
  api wrapper for alpaca.markets
  """
  require Jason

  @doc """
  gets account info
  """
  def account do
    get("/v2/account")
  end

  @doc """
  posts an order
  """
  def order(symbol, qty, side, type, time_in_force, limit_price \\ nil, stop_price \\ nil) do
    body = Jason.encode!(%{
      symbol: symbol,
      qty: qty,
      side: side,
      type: type,
      time_in_force: time_in_force,
      limit_price: limit_price,
      stop_price: stop_price})
    post("/v2/orders", body)
  end

  @doc """
  buy day market order wrapper
  """
  def buy(symbol, qty) do
    order(symbol, qty, "buy", "market", "day")
  end

  @doc """
  sell day market order wrapper
  """
  def sell(symbol, qty) do
    order(symbol, qty, "sell", "market", "day")
  end

  @doc """
  delete an order
  """
  def delete_order(id) do
    delete("/v2/orders/#{id}")
  end

  @doc """
  delete all orders
  """
  def delete_all_orders do
    delete("/v2/orders")
  end

  defp get(path) do
    url = Application.get_env(:alpa, :api) <> path
    HTTPoison.get(url, headers())
      |> handle_response
  end

  defp post(path, params) do
    url = Application.get_env(:alpa, :api) <> path
    HTTPoison.post(url, params, headers())
      |> handle_response
  end

  defp delete(path) do
    url = Application.get_env(:alpa, :api) <> path
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

  def headers do
    [
      "APCA-API-KEY-ID": Application.get_env(:alpa, :key),
      "APCA-API-SECRET-KEY": Application.get_env(:alpa, :secret)
    ]
  end

end

