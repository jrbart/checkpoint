defmodule CheckPointWeb.Schema.CheckMutationTest do
  use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase

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
        service: "green",
        args: "always pass", 
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
      assert cid === my_check.id
    end

    test "fails with bad contact name" do
      mutation = """
        description: "Test Check", 
        service: "green",
        args: "always pass", 
        contact: "bad_name"
      """

      mutation = "mutation { createCheck( #{mutation} ) { id } }"

      {:ok, %{data: %{"createCheck" => nil}, errors: [res]}} =
        Absinthe.run(
          mutation,
          Schema
        )

      assert res.message === "cannot find contact"
    end

    test "delete check" do
      {:ok, contact} =
        Checks.create_contact(%{
          name: "some_name",
          description: "Randy Bartels",
          type: "email",
          detail: "jrb@codingp.com"
        })

      {:ok, check} =
        Checks.create_check(%{
          description: "Test check",
          service: "green",
          args: "always pass",
          contact_id: contact.id
        })

      mutation = "mutation { deleteCheck( id: #{check.id} ) { id } }"

      {:ok, %{data: %{"deleteCheck" => %{"id" => cid}}}} =
        Absinthe.run(
          mutation,
          Schema
        )

      cid = String.to_integer(cid)
      {:error, _} = Checks.find_contact(%{id: cid})
    end
  end
end
