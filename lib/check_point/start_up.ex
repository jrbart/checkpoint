defmodule CheckPoint.StartUp do
  use GenServer, restart: :transient
  alias CheckPoint.Checks
  alias CheckPoint.Watcher
  @moduledoc false

  # Using a GenServer to pull check from database and fire
  # them up.  Maybe could use a Task here instead but
  # Jose on Elixir Forum says it is recommended to use a
  # Genserver.

  # Needed for GenServer implementation
  def start_link(arg), do: GenServer.start_link(__MODULE__, arg)

  @impl true
  def init(arg) do
    for ch <- Checks.list_checks() do
      service =
        ch.service
      |> CheckPoint.Service.validate()
      |> String.to_existing_atom()

      res = Watcher.start_watcher(ch.id, service, ch.args)
      res
    end

    {:ok, arg}
  end
end
