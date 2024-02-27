defmodule CheckPoint.Probes.Notify do
  use Task, restart: :transient
  @moduledoc false

  # A "run and done" Task
  def notify(check_id) do
    Task.Supervisor.start_child(
      CheckPoint.TaskSup,
      fn -> push_notify(check_id) end
    )
  end

  defp push_notify(id) do
    {:ok, check} = CheckPoint.Checks.find_check(id: id, preload: [:contact])
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, check_notify: check.id)
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, contact_notify: check.contact.name)
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
