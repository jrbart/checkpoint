defmodule CheckPoint.CheckTest do
	use ExUnit.Case
	doctest CheckPoint.Check
	alias CheckPoint.Check

describe "Check.http/1" do
		test "function exists" do
		  assert Check.http("http://www.google.com/") == :ok
		end
  end

describe "Check.green/1" do
    test "function returns :ok" do
      assert Check.green(true) == :ok
    end
end

describe "Check.red" do
    test "function returns false" do
      refute Check.red(:ok)
    end
  
end
end
