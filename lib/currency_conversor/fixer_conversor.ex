defmodule CurrencyConversor.FixerConversor do
  @moduledoc """
  An implementation of CurrencyConversor using Fixer.io

  Please add the following code in your config file to set the api key:

    config :currency_conversor, CurrencyConversor.FixerConversor, 
      api_key: "some-key"

  """
  @behaviour CurrencyConversor

  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.apilayer.com/fixer"
  plug Tesla.Middleware.JSON

  def convert(from, to, %Decimal{} = amount) do
    url = "/convert?from=#{from}&to=#{to}&amount=#{Decimal.to_float(amount)}"
    opts = [headers: [{"apikey", api_key!()}]]

    case get(url, opts) do
      {:ok, %Tesla.Env{status: 401, body: body}} ->
        {:error, body["message"]}

      {:ok, %Tesla.Env{status: 200, body: %{"success" => true, "result" => amount}}} ->
        {:ok, Decimal.from_float(amount)}

      {:ok, %Tesla.Env{status: 200, body: %{"error" => error}}} ->
        {:error, error}
    end
  end

  defp api_key! do
    Application.get_env(:currency_conversor, __MODULE__)[:api_key] ||
      raise("Fixer API KEY isn't configured.")
  end
end
