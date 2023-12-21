defmodule CheckPointWeb.Resolvers.Contact do
  use Absinthe.Schema.Notation
  alias CheckPoint.Checks

  def find(%{name: name}, _) do
    Checks.find_contact(%{name: name})
  end
end
