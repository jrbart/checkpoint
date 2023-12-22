defmodule CheckPoint.Checks do
  alias CheckPoint.Checks.{Contact,Check}
  alias EctoShorts.Actions

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    case Actions.find(Contact, params) do
      # For some reason Absinthe gets all discombobulated with %ErrorMessage
      {:error, _message} -> {:error, "No such contact"}
      res -> res
    end
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
    case Actions.find(Check, params) do
      # For some reason Absinthe gets all discombobulated with %ErrorMessage
      {:error, _message} -> {:error, "No such check"}
      res -> res
    end
  end

  def update_check(id, params) do
    Actions.update(Check, id, params)
  end

  def create_check(params) do
    Actions.create(Check, params)
  end
end
