defmodule CheckPoint.Record do
  use Task, restart: :transient

  def log(res,name)
  def log(res,name) when is_binary(name) do
    log_task = "log_" <> name
    run(log_task) 
    res
  end

  def log(res,id) when is_integer(id) do
    log_task = "log_#(id)"
    run(log_task)
    res
    # start the loop
  end

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    # ...
  end

end
