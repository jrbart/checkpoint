defmodule CheckPoint.Record do
  use Task, restart: :transient

  def log(res,name) do
    log_task = "log_" <> name
    run(log_task) 
    res
  end

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    # ...
  end

end
