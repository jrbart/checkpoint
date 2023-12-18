defmodule CheckPoint.Checks do
  alias CheckPoint.Checks.{Contact,Check}
  alias EctoShorts.Actions

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    Actions.find(Contact, params)
  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    Actions.create(Contact, params)  
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    Actions.find(Check, params)
  end

  def update_check(id, params) do
    Actions.update(Check, id, params)
  end

  def create_check(params) do
    Actions.create(Check, params)
  end
end
