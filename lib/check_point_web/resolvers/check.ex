defmodule CheckPointWeb.Resolvers.Check do
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{id: id}, _) do
    Checks.find_check(%{id: id, preload: :contact})
  end

  def create(params, _) do
{:ok, cid} = Checks.find_contact(%{name: params.contact})
    params 
      |> Map.delete(:contact)
      |> Map.put(:contact_id, cid.id)
      |> Checks.create_check
  end
end
