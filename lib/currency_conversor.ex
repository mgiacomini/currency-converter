defmodule CurrencyConversor do
  @moduledoc """
  This module defines behaviour and exposes a public API to convert amounts of money into another currencies.
  The behaviour was defined to allow us to change our implementation without change our clients (ex: Phoenix Controllers).

  If you want to change the default implementation, just replace the following config with the new one:

    config :currency_conversor, :adapter, CurrencyConversor.FixerConversor

  """

  @typedoc "Currency type using international notation. Ex: `BRL` for Brazilian Real"
  @type currency() :: String.t()

  @doc """
  Converts an amount from one currency to another one.

  ## Examples

    To convert USD 10 into EUR:

    iex> convert("USD", "EUR", Decimal.from_float(10.0))
    {:ok, %Decimal{...}}

  """
  @callback convert(currency(), currency(), Decimal.t()) :: {:ok, Decimal.t()} | {:error, any()}

  @doc "Calls an external service to get a real-time currency conversion"
  @spec convert(currency(), currency(), Decimal.t()) :: {:ok, Decimal.t()} | {:error, any()}
  def convert(from, to, amount) do
    impl!().convert(from, to, amount)
  end

  defp impl! do
    Application.get_env(:currency_conversor, :adapter) || raise "No adapter was configured."
  end
end
