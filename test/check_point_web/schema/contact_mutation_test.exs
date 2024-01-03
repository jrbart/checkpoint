defmodule CheckPointWeb.Schema.ContactMutationTest do
  use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase, async: false

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

    test "update contact" do
      {:ok, contact} =
        Checks.create_contact(%{
          name: "new_name",
          description: "Randy Bartels",
          type: "email",
          detail: "jrb@codingp.com"
        })

      mutation = """ 
        id: #{contact.id}
        name: "change_name", 
        detail: "bob@codingp.com" 
      """

      mutation = "mutation { updateContact( #{mutation} ) { id } }"

      {:ok, %{data: %{"updateContact" => %{"id" => cid}}}} =
        Absinthe.run(
          mutation,
          Schema
        )

      cid = String.to_integer(cid)
      {:ok, my_contact} = Checks.find_contact(%{id: cid})
      assert "change_name" == my_contact.name
      
    end
    
    test "delete contact" do
      {:ok, contact} =
        Checks.create_contact(%{
          name: "some_name",
          description: "Randy Bartels",
          type: "email",
          detail: "jrb@codingp.com"
        })

      mutation = "name: \"#{contact.name}\""

      mutation = "mutation { deleteContact( #{mutation} ) { id } }"

      {:ok, %{data: %{"deleteContact" => %{"id" => cid}}}} =
        Absinthe.run(
          mutation,
          Schema
        )

      cid = String.to_integer(cid)
      {:error, _} = Checks.find_contact(%{id: cid})
      # assert "change_name" == my_contact.nam
      
    end
  end
end
