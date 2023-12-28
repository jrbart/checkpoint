defmodule CheckPoint.CheckTest do
	use ExUnit.Case
	doctest CheckPoint.Action
	alias CheckPoint.Action

describe "Check.http/1" do
		test "function exists" do
		  assert Action.Http.check("http://www.google.com/") == :ok
		end
  end

describe "Check.green/1" do
    test "function returns :ok" do
      assert Action.Green.check(true) == :ok
    end
end

describe "Check.red" do
    test "function returns false" do
      refute Action.Red.check(:ok)
    end
  
end
end
