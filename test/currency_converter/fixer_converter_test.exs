defmodule CurrencyConverter.FixerConverterTest do
  use ExUnit.Case
  import Tesla.Mock

  alias CurrencyConverter.FixerConverter

  @amount Decimal.from_float(100.0)
  @from "BRL"
  @to "USD"

  describe "convert/3" do
    setup context do
      if context[:without_api_key] do
        Application.put_env(:currency_converter, FixerConverter, api_key: nil)
      else
        Application.put_env(:currency_converter, FixerConverter, api_key: "some-key")
      end

      :ok
    end

    @tag :without_api_key
    test "raises an error when api key isn't configured" do
      assert_raise RuntimeError, "Fixer API KEY isn't configured.", fn ->
        FixerConverter.convert(@from, @to, @amount)
      end
    end

    test "returns error when api key is invalid" do
      mock(fn %{method: :get} ->
        json(%{"message" => "Invalid authentication credentials"}, status: 401)
      end)

      assert {:error, "Invalid authentication credentials"} ==
               FixerConverter.convert(@from, @to, @amount)
    end

    test "returns error when *from* currency is invalid" do
      expected_error = %{
        "code" => 402,
        "info" => "You have entered an invalid \"from\" property. [Example: from=EUR]",
        "type" => "invalid_from_currency"
      }

      mock(fn %{method: :get} ->
        json(%{"error" => expected_error}, status: 200)
      end)

      assert {:error, expected_error} == FixerConverter.convert("xxx", @to, @amount)
    end

    test "returns error when *to* currency is invalid" do
      expected_error = %{
        "code" => 402,
        "info" => "You have entered an invalid \"to\" property. [Example: to=GBP]",
        "type" => "invalid_to_currency"
      }

      mock(fn %{method: :get} ->
        json(%{"error" => expected_error}, status: 200)
      end)

      assert {:error, expected_error} == FixerConverter.convert(@from, "xxx", @amount)
    end

    test "returns the converted amount" do
      mock(fn %{method: :get, url: url, headers: headers} ->
        assert expected_url(@from, @to, @amount) == url
        assert expected_headers() == headers
        json(%{"success" => true, "result" => 20.0952}, status: 200)
      end)

      assert {:ok, Decimal.from_float(20.0952)} == FixerConverter.convert(@from, @to, @amount)
    end

    defp expected_url(from, to, amount) do
      "https://api.apilayer.com/fixer/convert?from=#{from}&to=#{to}&amount=#{amount}"
    end

    defp expected_headers do
      api_key = Application.get_env(:currency_converter, FixerConverter)[:api_key]
      [{"apikey", api_key}]
    end
  end
end
