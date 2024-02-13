defmodule CheckPoint.Notify do
  use Task, restart: :transient
  @moduledoc false

  def maybe_notify(res, name, level)

  # If the Probe test passed, return :ok
  def maybe_notify(:ok, _, _), do: :ok

  # if level has reached 3 tries, then create a task to notify
  def maybe_notify(res, check_id, 3) do
    Task.Supervisor.start_child(
      CheckPoint.TaskSup,
      fn -> push_notify(check_id) end
    )

    res
  end

  # If level is greater than 3 then just return
  # Pass through the result code
  def maybe_notify(res, _, _), do: res

  def push_notify(id) do
    {:ok, check} = CheckPoint.Checks.find_check(id: id, preload: [:contact])
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, check_notify: check.id)
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, contact_notify: check.contact.id)
  end

  # Task implementation

  def start_link(check_id) do
    Task.start(__MODULE__, :run, [check_id])
  end

  # Future expansion will use contact type to custom tailor notify
  # but for now just trigger GraphQL Subscription
  def run(check_id) do
    push_notify(check_id)
  end
end
