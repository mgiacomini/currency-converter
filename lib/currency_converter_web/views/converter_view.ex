defmodule CurrencyConverterWeb.ConverterView do
  use CurrencyConverterWeb, :view

  def render("conversion.json", %{amount: amount}) do
    %{data: %{amount: amount}}
  end

  def render("conversion_error.json", %{reason: reason}) do
    %{error: %{reason: reason}}
  end
end
