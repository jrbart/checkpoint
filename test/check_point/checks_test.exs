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

describe "Checks.create_contact/1" do
		test "function exists" do
		  assert Checks.create_contact(@contact)
		end
	end
  
# create_contact can also create_check

# contact name must be unique

# create_check

# create_check must take a contact

 end
