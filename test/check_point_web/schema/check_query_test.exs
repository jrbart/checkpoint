defmodule CheckPointWeb.Schema.CheckQueryTest do
  use ExUnit.Case
  alias Ecto.Adapter.Schema
  use CheckPoint.RepoCase, async: false

  alias CheckPointWeb.Schema
  alias CheckPoint.Checks

  describe "&check" do
    test "retrieves check by id" do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }

      {:ok, check} =
        Checks.create_check(%{
          description: "test",
          action: "green",
          args: "test",
          contact: contact
        })

      {:ok, %{data: %{"check" => %{"id" => cid}}}} =
        Absinthe.run(
          "query { check( id: \"#{check.id}\") { id }}",
          Schema
        )

      assert check.id == String.to_integer(cid)
    end

    test "does not raise or die if they don't exist" do
      Absinthe.run(
        "query { check( id: 0) { id }}",
        Schema
      )
    end
  end
end
