defmodule CheckPoint.Record do
  use Task, restart: :transient

  def log(res,id) do
    run(id,res) 
    res
  end

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(op,res) do
    # ...
    CheckPoint.Repo.insert(
      CheckPoint.Checks.Log.changeset(
        %CheckPoint.Checks.Log{}, %{action: "check", op: op, description: to_string(res)}))
  end

end
