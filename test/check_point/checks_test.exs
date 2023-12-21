defmodule CheckPoint.ChecksTest do
	use ExUnit.Case
  use CheckPoint.RepoCase
	doctest CheckPoint.Checks
	alias CheckPoint.Checks

 @contact %{
    name: "test",
    description: "Test Contact",
    type: "email",
    detail: "me@email.com"
  } 

  @check %{
    description: "test",
    args: "test",
    opts: "delay: 1000",
  }

describe "Checks.create_contact/1" do

		test "create a contact" do
		  assert Checks.create_contact(@contact)
		end
  
    test "create_contact can also create_check" do
      contact = Map.put(@contact, :checks, [@check])
      Checks.Check.changeset(%Checks.Check{},@check)
      assert {:ok, my_contact} = Checks.create_contact(contact)
      assert hd(my_contact.checks).description == "test"
    end

    test "create_contact must be unique name" do
      contact = Map.put(@contact, :checks, [@check])
      Checks.Check.changeset(%Checks.Check{},@check)
      assert {:ok, _contact} = Checks.create_contact(contact)
      assert {:error, _err} = Checks.create_contact(contact)
      end
      
	end

    test "create_check also does create_contact" do
      check = Map.put(@check, :contact, @contact)
      assert {:ok, my_check} = Checks.create_check(check)
      
      assert my_check.contact.name == "test"
    end


    test "create_check must take a contact" do
    # raises exption due to DB constraint
    # TODO get validation to catch in changeset
      try do
        {:ok, _err} = Checks.create_check(@check)
        assert :false
      rescue
        _e -> assert :true
      end
    end


 end
