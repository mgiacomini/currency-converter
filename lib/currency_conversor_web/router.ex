defmodule CurrencyConversorWeb.Router do
  use CurrencyConversorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurrencyConversorWeb do
    pipe_through :api
  end
end
