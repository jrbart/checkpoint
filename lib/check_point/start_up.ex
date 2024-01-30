defmodule CheckPoint.StartUp do
  use Task
  alias CheckPoint.Checks
  alias CheckPoint.Watcher
  @moduledoc false

  # Using a GenServer to pull check from database and fire
  # them up.  Maybe could use a Task here instead but
  # Jose on Elixir Forum says it is recommended to use a
  # Genserver.

  # Needed for GenServer implementation
  def start_link(_arg), do: Task.start_link(__MODULE__, :run, [])

  def run do
    for ch <- Checks.list_checks() do
      service =
        ch.service
      |> CheckPoint.Service.validate()
      |> String.to_existing_atom()

      res = Watcher.start_watcher(ch.id, service, ch.args)
      res
    end

    {:ok, :normal}
  end
end
