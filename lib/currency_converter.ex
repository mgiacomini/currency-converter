defmodule CurrencyConverter do
  @moduledoc """
  This module defines a behaviour and exposes a public API to convert amounts of money into another currencies.
  The behaviour was defined to allow us to change our implementation without change our clients (ex: Phoenix Controllers).

  If you want to change the default implementation, just replace the following config with the new one:

    config :currency_converter, :adapter, CurrencyConverter.FixerConversor

  """

  @typedoc "Currency type using international notation. Ex: `BRL` for Brazilian Real"
  @type currency() :: String.t() | nil

  @type error_message() :: String.t()

  @doc """
  Converts an amount from one currency to another one.

  ## Examples

    To convert USD 10 into EUR:

    iex> convert("USD", "EUR", Decimal.from_float(10.0))
    {:ok, %Decimal{...}}

  """
  @callback convert(currency(), currency(), Decimal.t()) ::
              {:ok, Decimal.t()} | {:error, error_message()} | no_return()

  @doc "Calls an external service to get a real-time currency conversion"
  @spec convert(currency(), currency(), Decimal.t()) ::
          {:ok, Decimal.t()} | {:error, error_message()} | no_return()
  def convert(from, to, amount), do: impl!().convert(from, to, amount)

  defp impl! do
    Application.get_env(:currency_converter, :adapter) || raise "No adapter was configured."
  end
end
