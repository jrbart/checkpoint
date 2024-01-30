defmodule CheckPoint.StartUp do
  use Task
  alias CheckPoint.Checks
  alias CheckPoint.Watcher
  @moduledoc false

  def start_link(_arg), do: Task.start_link(__MODULE__, :run, [])

  def run do
    for ch <- Checks.list_checks() do
      probe =
        ch.probe
        |> CheckPoint.Probe.validate()
        |> String.to_existing_atom()

      Watcher.start_watcher(ch.id, probe, ch.args)
    end

    {:ok, :normal}
  end
end
