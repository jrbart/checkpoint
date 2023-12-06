defmodule CheckPoint.Escalate do
  use Task, restart: :transient

  def alert(res, name, level)

  def alert(:ok, _, _), do: :ok
  def alert(:up, _, _), do: :up

  def alert(res, name, 5) do
    Task.start(__MODULE__, :run, [name])

    res
  end

  def alert(res, _, _), do: res

  def start_link(arg) do
    Task.start(__MODULE__, :run, [arg])
  end

  def run(arg) do
    # ...
    IO.inspect(arg)
    Process.sleep(:infinity)
  end
end
