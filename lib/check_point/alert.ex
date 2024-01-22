defmodule CheckPoint.Alert do
  use Task, restart: :transient
  @moduledoc false

  def alert(res, name, level)

  # If the service test passed, return :ok
  def alert(:ok, _, _), do: :ok

  # if level has reached % tries, then create a task to send an alert
  def alert(res, check_id, 5) do
    Task.start(__MODULE__, :run, [check_id])

    res
  end

  # If level is greater than 5 then just return
  # Pass through the result code
  def alert(res, _, _), do: res

  # Task implementation
  def start_link(check_id) do
    Task.start(__MODULE__, :run, [check_id])
  end

  # Future expansion will use contact type to custom tailor alert
  # but for now just trigger GraphQL Subscription
  def run(check_id) do
    CheckPoint.Checks.push_alert(check_id)
  end
end
