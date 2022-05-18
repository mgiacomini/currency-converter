defmodule CurrencyConverterTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  @amount Decimal.from_float(100.0)
  @from "BRL"
  @to "USD"

  describe "convert/3" do
    test "raises an error if no implementation was configured" do
      Application.put_env(:currency_converter, :adapter, nil)

      assert_raise RuntimeError, "No adapter was configured.", fn ->
        CurrencyConverter.convert("", "", %Decimal{})
      end
    end

    test "returns the adapter response" do
      Application.put_env(:currency_converter, :adapter, CurrencyConverter.MockConverter)

      expect(CurrencyConverter.MockConverter, :convert, fn @from, @to, @amount ->
        {:ok, %Decimal{}}
      end)

      assert {:ok, %Decimal{}} == CurrencyConverter.convert(@from, @to, @amount)
    end
  end
end
