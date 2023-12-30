defmodule CheckPointWeb.Schema.ContactQueryTest do
	use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase, async: true

  alias CheckPointWeb.Schema
  alias CheckPoint.Checks

  describe "&contact" do
    test "retrieves contact by name" do
      {:ok, contact} =
        Checks.create_contact(%{
          name: "new_name",
          description: "Randy Bartels",
          type: "email",
          detail: "jrb@codingp.com"
        })

      {:ok, %{data: %{"contact" => %{"name" => cname}}}} =
        Absinthe.run(
          "query { contact( name: \"#{contact.name}\") { name }}",
          Schema
        )

      assert contact.name == cname
    end

    test "does not raise or die if they don't exist" do
      Absinthe.run(
        "query { contact( name: \"not_this_name\") { name }}",
        Schema
      )
      |> IO.inspect
    end

    test "retrieves all checks for contact" do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }
      {:ok, contact} =
      Checks.create_contact( contact )

      Checks.create_check(%{
        description: "test1",
        action: "green",
        args: "test",
        opts: "",
        contact_id: contact.id
      })

      Checks.create_check(%{
        description: "test2",
        action: "green",
        args: "test",
        opts: "",
        contact_id: contact.id
      })

      {:ok, %{data: %{"contact" => %{"checks" => list}}}} =
        Absinthe.run(
          "query { contact( name: \"#{contact.name}\") { checks {id} }}",
          Schema
        )

      assert length(list) == 2
    end
  end
end
