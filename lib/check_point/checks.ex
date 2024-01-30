defmodule CheckPoint.Checks do
  alias CheckPoint.{Watcher,Alarm}
  alias CheckPoint.Checks.{Contact, Check}
  alias EctoShorts.Actions
  @moduledoc false

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    case Actions.find(Contact, Map.put_new(params, :preload, [:checks])) do
      # Add info fields from workers to the result
      {:error, %ErrorMessage{} = err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}

      {:ok, contact} ->
        {:ok,
         contact
         |> Map.update(
           :checks,
           nil,
           &Enum.map(&1, fn ch ->
             Map.put_new(ch, :is_alive, Watcher.status(ch.id))
           end)
         )
         |> Map.update(
           :checks,
           nil,
           &Enum.map(&1, fn ch ->
             Map.put_new(ch, :level, Alarm.state(ch.id))
           end)
         )}
    end
  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    Actions.create(Contact, params)
  end

  def delete_contact(params) do
    case Actions.delete(Contact, params) do
      {:error, err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}

      res ->
        res
    end
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    with {:ok, check} <- Actions.find(Check, params),
         stat <- Watcher.status(check.id),
         state <- Watcher.state(check.id) do
      # Add info fields from workers to the result
      {:ok,
       check
       |> Map.put_new(:is_alive, stat)
       |> Map.put_new(:level, state)}
    else
      {:error, err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}
    end
  end

  def create_check(params) do
    # convert probe from string to function (atom)
    probe =
      params[:probe]
      |> CheckPoint.Probe.validate()
      |> String.to_existing_atom()

    args = params[:args]
    # add to database, then if successful, start a worker
    with {:ok, check} <- Actions.create(Check, params),
         {:ok, _pid} <- Watcher.start_watcher(check.id, probe, args) do
      stat = Watcher.status(check.id)
      state = Watcher.state(check.id)
      # Add info fields from workers to the result
      {:ok,
       check
       |> Map.put_new(:is_alive, stat)
       |> Map.put_new(:level, state)}
    else
      {:error, err} -> {:error, err}
    end
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    # stop the worker first, then if successful remove from database
    Watcher.kill(id)

    with {:error, err} <- Actions.delete(Check, id) do
      {:error, ErrorMessage.to_jsonable_map(err)}
    end
  end

  def push_notify(id) do
    {:ok, check} = CheckPoint.Checks.find_check(id: id, preload: [:contact])
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, check_notify: check.id)
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, contact_notify: check.contact.id)
  end
end
