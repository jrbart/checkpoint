defmodule CheckPoint.CheckWatcher do
  alias CheckPoint.{Checks, Probes, Probes.Watcher}

  def create_start(params) do
    # convert probe from string to function (atom)
    probe = Probes.to_atom(params[:probe])

    args = params[:args]
    # add to database and start a watcher
    {:ok, check} = Checks.create_check(params)
    {:ok, _pid} = Watcher.start_watcher(check.id, probe, args)
    {:ok, check}
  end

  def kill_delete(%{id: id}) do
    id = String.to_integer(id)
    # stop the worker first, then if successful remove from database
    Watcher.kill(id)
    Checks.delete_check(id)
  end
end
