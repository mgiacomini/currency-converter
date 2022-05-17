defmodule CurrencyConversor.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CurrencyConversorWeb.Telemetry,
      CurrencyConversorWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CurrencyConversor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CurrencyConversorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
