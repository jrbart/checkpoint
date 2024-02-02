defmodule CheckPointWeb.Resolvers.Contact do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{name: name}, _) do
    case Checks.find_contact(%{name: name, preload: :checks}) do
      {:error, _} -> {:error, "contact not found"}
      res -> res
    end
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
