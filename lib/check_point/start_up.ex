defmodule CheckPoint.StartUp do
  use Task
  alias CheckPoint.Checks
  alias CheckPoint.Watcher
  @moduledoc false

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
