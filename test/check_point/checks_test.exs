defmodule CheckPoint.ChecksTest do
	use ExUnit.Case
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
      contact = Map.put(@contact, :check, [@check])
      Checks.Check.changeset(%Checks.Check{},@check)
      assert {:ok, my_contact} = Checks.create_contact(contact)
      
      assert hd(my_contact.check).description == "test"
    end
	end

# contact name must be unique

    test "create_check also does create_contact" do
      check = Map.put(@check, :contact, @contact)
      assert {:ok, my_check} = Checks.create_check(check)
      
      assert my_check.contact.name == "test"
    end


    test "create_check must take a contact" do
      assert {:error, err} = Checks.create_check(@check)
    #IO.inspect(err)
    end


 end
