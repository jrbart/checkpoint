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
      # Start the PubSub system
      {Phoenix.PubSub, name: CheckPoint.PubSub},
      # Start Finch
      {Finch, name: CheckPoint.Finch},
      # Start the Endpoint (http/https)
      CheckPointWeb.Endpoint,
      # Start a worker by calling: CheckPoint.Worker.start_link(arg)
      # {CheckPoint.Worker, arg}
      {CheckPoint.DynSup, strategy: :one_for_one},
      {Registry, keys: :unique, name: CheckPoint.WorkerReg}

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
