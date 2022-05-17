defmodule CurrencyConversor do
  @moduledoc """
  This module defines an adapter interface and exposes a public API to convert amounts of money into another currencies.
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
