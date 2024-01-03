defmodule CheckPoint.Escalate do
  use Task, restart: :transient

  def alert(res, name, level)

  # These two cases are passing so just return
  def alert(:ok, _, _), do: :ok
  def alert(:up, _, _), do: :up

  # if level has reached % tries, then create a task to send an alert
  def alert(res, name, 5) do
    Task.start(__MODULE__, :run, [name])

    res
  end

  # If level is greater than 5 then just return
  # Pass through the result code
  def alert(res, _, _), do: res

  def start_link(arg) do
    Task.start(__MODULE__, :run, [arg])
  end

  # Future expansion will use contact type to custom tailor alert
  # but for now just trigger GraphQL Subscription
  def run(id) do
    {:ok, check} = CheckPoint.Checks.find_check(id: id, preload: [:contact])
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, check_alert: check.id)
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, contact_alert: check.contact.id)
    CheckPoint.Repo.insert(
      CheckPoint.Checks.Log.changeset(
        %CheckPoint.Checks.Log{}, %{action: "alert", op: check.id, description: "check"}))
    CheckPoint.Repo.insert(
      CheckPoint.Checks.Log.changeset(
        %CheckPoint.Checks.Log{}, %{action: "alert", op: check.contact.id, description: "contact"}))
  end
end
