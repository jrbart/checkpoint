defmodule CheckPointWeb.Resolvers.Check do
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{id: id}, _) do
    Checks.find_check(%{id: id, preload: :contact})
  end
end
