defmodule CheckPointWeb.Resolvers.Contact do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{name: name}, info) do
    # Got this from https://hexdocs.pm/absinthe/Absinthe.Resolution.html#project/2
    child_fields = info |> Absinthe.Resolution.project() |> Enum.map(& &1.name)
    maybe_preload = if "checks" in child_fields, do: %{preload: :checks}, else: %{}

    case Checks.find_contact(Map.merge(%{name: name}, maybe_preload)) do
      {:ok, _} = res ->
        res

      _ -> 
        {:error, "Contact not found"}
    end
  end

  def create(params, _) do
    Checks.create_contact(params)
  end

  def update(params, _) do
    Checks.update_contact(params[:id], params)
  end

  def delete(%{name: name}, _) do
    {:ok, contact} = Checks.find_contact(%{name: name})
    Checks.delete_contact(contact.id)
  end
end
