defmodule CurrencyConverter.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts(System.get_env("FIXER_API_KEY"))

    children = [
      CurrencyConverterWeb.Telemetry,
      CurrencyConverterWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CurrencyConverter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CurrencyConverterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
