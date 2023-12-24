defmodule CheckPointWeb.Schema.ContactMutationTest do
  use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase, async: true

  alias CheckPointWeb.Schema
  alias CheckPoint.Checks

  describe "&createContact" do
    test "create a contact" do
      mutation = """ 
        name: "new_name", 
        description: "Randy Bartels", 
        type: "email", 
        detail: "jrb@codingp.com" 
      """

      mutation = "mutation { createContact( #{mutation} ) { id } }"

      {:ok, %{data: %{"createContact" => %{"id" => cid}}}} =
        Absinthe.run(
          mutation,
          Schema
        )

      cid = String.to_integer(cid)
      {:ok, my_contact} = Checks.find_contact(%{id: cid})
      assert cid == my_contact.id
    end
  end
end
