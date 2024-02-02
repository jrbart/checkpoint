defmodule CheckPoint.Checks do
  alias CheckPoint.Watcher
  alias CheckPoint.Checks.{Contact, Check}
  alias EctoShorts.Actions
  @moduledoc false

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    Actions.find(Contact, Map.put_new(params, :preload, [:checks]))
  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    Actions.create(Contact, params)
  end

  def delete_contact(params) do
    Actions.delete(Contact, params)
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    Actions.find(Check, params)
  end

  def create_check(params) do
    # convert probe from string to function (atom)
    probe =
      params[:probe]
      |> CheckPoint.Probe.validate()
      |> String.to_existing_atom()

    args = params[:args]
    # add to database and start a watcher
    {:ok, check} = Actions.create(Check, params)
    {:ok, _pid} = Watcher.start_watcher(check.id, probe, args)
    {:ok, check}
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    # stop the worker first, then if successful remove from database
    Watcher.kill(id)
    Actions.delete(Check, id)
  end

  def push_notify(id) do
    {:ok, check} = CheckPoint.Checks.find_check(id: id, preload: [:contact])
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, check_notify: check.id)
    Absinthe.Subscription.publish(CheckPointWeb.Endpoint, check, contact_notify: check.contact.id)
  end
end
