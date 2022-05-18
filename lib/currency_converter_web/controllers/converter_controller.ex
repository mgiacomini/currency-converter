defmodule CurrencyConverterWeb.ConverterController do
  use CurrencyConverterWeb, :controller

  @spec convert(Plug.Conn.t(), any) :: Plug.Conn.t()
  def convert(conn, %{"amount" => amount}) when not is_float(amount) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("conversion_error.json", reason: "amount must be a float")
  end

  def convert(conn, params) do
    case CurrencyConverter.convert(
           params["from"],
           params["to"],
           Decimal.from_float(params["amount"])
         ) do
      {:ok, amount} ->
        render(conn, "conversion.json", amount: amount)

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("conversion_error.json", reason: reason)
    end
  end
end
