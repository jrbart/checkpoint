defmodule CheckPointWeb.Resolvers.Contact do
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
    Checks.update_contact(id,params)
  end
end
