defmodule CheckPoint.CheckTest do
  @moduledoc false
  use ExUnit.Case
  alias CheckPoint.Probes.Probe

  describe "Check.http/1" do
    test "function exists" do
      assert Probe.http("http://www.google.com/") === :ok
    end
  end

  describe "Check.green/1" do
    test "function returns :ok" do
      assert Probe.green(true) === :ok
    end
  end

  describe "Check.red" do
    test "function returns false" do
      refute Probe.red(:ok)
    end
  end
end
