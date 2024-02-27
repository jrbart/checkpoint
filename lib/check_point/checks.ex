defmodule CheckPoint.Checks do
  alias CheckPoint.Checks.{Contact, Check}
  alias EctoShorts.Actions
  @moduledoc false

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    Actions.find(Contact, params)
  end

  def update_contact(name, params) do
    Actions.find_and_update(Contact, %{name: name}, params)
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
    Actions.create(Check, params)
  end

  def delete_check(params) do
    Actions.delete(Check, params)
  end
end
