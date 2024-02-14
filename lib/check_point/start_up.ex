defmodule CheckPoint.StartUp do
  use Task
  alias CheckPoint.Checks
  alias CheckPoint.Probes.Watcher
  alias CheckPoint.Probes
  @moduledoc false

  def start_link(_arg), do: Task.start_link(__MODULE__, :run, [])

  def run do
    for ch <- Checks.list_checks() do
      probe = Probes.to_atom(ch.probe)

      Watcher.start_watcher(ch.id, probe, ch.args)
    end

    {:ok, :normal}
  end
end
