defmodule CheckPoint.CheckTest do
  @moduledoc false
  use ExUnit.Case
  alias CheckPoint.Service

  describe "Check.http/1" do
    test "function exists" do
      assert Service.http("http://www.google.com/") === :ok
    end
  end

  describe "Check.green/1" do
    test "function returns :ok" do
      assert Service.green(true) === :ok
    end
  end

  describe "Check.red" do
    test "function returns false" do
      refute Service.red(:ok)
    end
  end
end
