defmodule CheckPointWeb.Schema.CheckMutationTest do
  use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase, async: true

  alias CheckPointWeb.Schema
  alias CheckPoint.Checks

  describe "&createCheck" do
    test "create a check" do
      # checks must be linked to a contact
      {:ok, contact} =
        Checks.create_contact(%{
          name: "some_name",
          description: "Randy Bartels",
          type: "email",
          detail: "jrb@codingp.com"
        })
      
      mutation = """ 
        description: "Test Check", 
        args: "google.com", 
        opts: "" 
        contact: \"#{contact.name}\"
      """

      mutation = "mutation { createCheck( #{mutation} ) { id } }"

      {:ok, %{data: %{"createCheck" => %{"id" => cid}}}} =
        Absinthe.run(
          mutation,
          Schema
        )

      cid = String.to_integer(cid)
      {:ok, my_check} = Checks.find_check(%{id: cid})
      assert cid == my_check.id
    end

    test "fails with bad contact name" do
      mutation = """ 
        description: "Test Check", 
        args: "google.com", 
        opts: "" 
        contact: "bad_name"
      """

      mutation = "mutation { createCheck( #{mutation} ) { id } }"

      {:ok, %{data: %{"createCheck" => nil}, errors: [res]}} =
        Absinthe.run(
          mutation,
          Schema
        )

      assert res.message == "cannot find contact"
    end
  #   test "update contact" do
  #     {:ok, contact} =
  #       Checks.create_contact(%{
  #         name: "new_name",
  #         description: "Randy Bartels",
  #         type: "email",
  #         detail: "jrb@codingp.com"
  #       })

  #     mutation = """ 
  #       id: #{contact.id}
  #       name: "change_name", 
  #       detail: "bob@codingp.com" 
  #     """

  #     mutation = "mutation { updateContact( #{mutation} ) { id } }"

  #     {:ok, %{data: %{"updateContact" => %{"id" => cid}}}} =
  #       Absinthe.run(
  #         mutation,
  #         Schema
  #       )

  #     cid = String.to_integer(cid)
  #     {:ok, my_contact} = Checks.find_contact(%{id: cid})
  #     assert "change_name" == my_contact.name
  #     
  #   end
  #   
  #   test "delete contact" do

  #     mutation = "name: \"#{contact.name}\""

  #     mutation = "mutation { deleteContact( #{mutation} ) { id } }"

  #     {:ok, %{data: %{"deleteContact" => %{"id" => cid}}}} =
  #       Absinthe.run(
  #         mutation,
  #         Schema
  #       )

  #     cid = String.to_integer(cid)
  #     {:error, _} = Checks.find_contact(%{id: cid})
  #     # assert "change_name" == my_contact.nam
  #     
  #   end
   end
end
