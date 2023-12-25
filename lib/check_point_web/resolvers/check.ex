defmodule CheckPointWeb.Resolvers.Check do
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{id: id}, _) do
    Checks.find_check(%{id: id, preload: :contact})
  end

  def create(params, _) do
    case Checks.find_contact(%{name: params.contact}) do
    {:error, _} -> {:error, "cannot find contact"}   
    {:ok, cid} ->
      params 
        |> Map.delete(:contact)
        |> Map.put(:contact_id, cid.id)
        |> Checks.create_check
      end
  end
end
