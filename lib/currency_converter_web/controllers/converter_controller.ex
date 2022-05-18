defmodule CurrencyConverterWeb.ConverterController do
  use CurrencyConverterWeb, :controller

  @spec convert(Plug.Conn.t(), map) :: Plug.Conn.t()
  def convert(conn, %{} = attrs) do
    with {:ok, attrs} <- validate_and_cast_attrs(attrs),
         {:ok, amount} <- CurrencyConverter.convert(attrs["from"], attrs["to"], attrs["amount"]) do
      render(conn, "conversion.json", amount: amount)
    else
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("conversion_error.json", reason: reason)
    end
  end

  defp validate_and_cast_attrs(%{} = attrs) do
    amount = attrs["amount"]

    if is_float(amount),
      do: {:ok, Map.put(attrs, "amount", Decimal.from_float(amount))},
      else: {:error, "amount must be a float"}
  end
end
