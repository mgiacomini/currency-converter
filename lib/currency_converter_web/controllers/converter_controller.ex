defmodule CurrencyConverterWeb.ConverterController do
  use CurrencyConverterWeb, :controller

  @spec convert(Plug.Conn.t(), any) :: Plug.Conn.t()
  def convert(conn, params) do
    case CurrencyConverter.convert(params["from"], params["to"], params["amount"]) do
      {:ok, amount} ->
        render(conn, "conversion.json", amount: amount)

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("conversion_error.json", reason: reason)
    end
  end
end
