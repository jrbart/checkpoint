defmodule CheckPointWeb.Resolvers.Contact do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{name: name}, _) do
    Checks.find_contact(%{name: name, preload: :checks})
  end

  def create(params, _) do
    Checks.create_contact(params)
  end

  def update(params, _) do
    id = params.id
    Checks.update_contact(id, params)
  end

  def delete(%{name: name}, _) do
    {:ok, contact} = Checks.find_contact(%{name: name})
    Checks.delete_contact(contact.id)
  end
end
