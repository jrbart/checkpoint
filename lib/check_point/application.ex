defmodule CheckPoint.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      :check_point
      |> Application.get_env(:environment, :prod)
      |> children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CheckPoint.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:common) do
    [
      # Start the Telemetry supervisor
      CheckPointWeb.Telemetry,
      # Start the Endpoint (http/https)
      CheckPointWeb.Endpoint,
      # Start the PubSub system
      {Phoenix.PubSub, name: CheckPoint.PubSub},
      {Absinthe.Subscription, CheckPointWeb.Endpoint},
      # Start Finch
      {Finch, name: CheckPoint.Finch},
      # Start a Dynamic Supervisor for Watcher
      {DynamicSupervisor, strategy: :one_for_one, name: CheckPoint.WatchSup},
      {Registry, keys: :unique, name: CheckPoint.WatcherReg},
      # Start a Dynamic Supervisor for Alarm
      {DynamicSupervisor, strategy: :one_for_one, name: CheckPoint.AlarmSup},
      # Start a Supervisor for fire-and-forget Tasks
      # (StartUp Task and Notify Tasks)
      {Task.Supervisor, name: CheckPoint.TaskSup},
      {Registry, keys: :unique, name: CheckPoint.AlarmReg},
      CheckPoint.Repo
    ]
  end

  defp children(:test) do
    children(:common)
  end

  defp children(_) do
    children(:common) ++
      [
        # Load existing checks from database on startup
        {CheckPoint.StartUp, name: CheckPoint.StartUp}
      ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CheckPointWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
