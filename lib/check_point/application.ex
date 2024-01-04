defmodule CheckPoint.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CheckPointWeb.Telemetry,
      # Start the Endpoint (http/https)
      CheckPointWeb.Endpoint,
      # Start the PubSub system
      {Phoenix.PubSub, name: CheckPoint.PubSub},
      {Absinthe.Subscription, CheckPointWeb.Endpoint},
      # Start Finch
      {Finch, name: CheckPoint.Finch},
      # Start a Dynamic Supervisor for Workers
      {CheckPoint.DynSup, strategy: :one_for_one},
      {Registry, keys: :unique, name: CheckPoint.WorkerReg},
      CheckPoint.Repo,
      # Load existing checks from database on startup
      CheckPoint.StartUp
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CheckPoint.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CheckPointWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
