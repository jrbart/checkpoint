defmodule CheckPoint.StartUp do
  use GenServer, restart: :transient
  alias CheckPoint.Checks
  alias CheckPoint.Worker
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
      action =
        String.to_existing_atom("Elixir.CheckPoint.Action." <> String.capitalize(ch.action))

      res = Worker.run_check(ch.id, &action.check/1, ch.args)
      res
    end

    {:ok, arg}
  end
end
