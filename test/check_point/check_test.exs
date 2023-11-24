defmodule CheckPoint.CheckTest do
	use ExUnit.Case
	doctest CheckPoint.Check
	alias CheckPoint.Check

describe "Check.ping/1" do
		test "function exists" do
		  assert Check.ping("127.0.0.1") in [:ok, :error]
		end
	end

describe "Check.port/1" do
		test "function exists" do
		  assert Check.port("127.0.0.1",80) in [:ok, :error]
		end
	end

describe "Check.http/1" do
		test "function exists" do
		  assert Check.http("127.0.0.1:80") in [:ok, :error]
		end
  end
end
