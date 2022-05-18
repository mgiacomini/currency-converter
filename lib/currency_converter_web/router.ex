defmodule CurrencyConverterWeb.Router do
  use CurrencyConverterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CurrencyConverterWeb do
    pipe_through :api

    post "/convert", ConverterController, :convert
  end
end
