defmodule CurrencyConverterWeb.ConverterControllerTest do
  use CurrencyConverterWeb.ConnCase, async: true
  import Mox

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "convert/2" do
    test "renders 200 and the converted amount", %{conn: conn} do
      attrs = %{
        amount: 1,
        from: "BRL",
        to: "USD"
      }

      stub(CurrencyConverter.MockConverter, :convert, fn _from, _to, _amount ->
        {:ok, Decimal.from_float(4.5)}
      end)

      conn = post(conn, Routes.converter_path(conn, :convert), attrs)
      assert json_response(conn, 200)["data"] == %{"amount" => "4.5"}
    end

    test "renders 422 with errors attrs are invalid", %{conn: conn} do
      attrs = %{
        amount: "xxx",
        from: "xxx",
        to: "xxx"
      }

      stub(CurrencyConverter.MockConverter, :convert, fn _from, _to, _amount ->
        {:error, "Some error message"}
      end)

      conn = post(conn, Routes.converter_path(conn, :convert), attrs)
      assert json_response(conn, 422)["error"] == %{"reason" => "Some error message"}
    end
  end
end
