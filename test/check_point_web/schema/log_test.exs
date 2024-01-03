defmodule CheckPointWeb.Schema.LogTest do
  use ExUnit.Case
  alias ElixirSense.Log
  use CheckPoint.RepoCase, async: false

  describe "Log" do
    test "retrieve contact logs via GraphQL" do
    {:ok, log} =
        CheckPoint.Repo.insert(
          CheckPoint.Checks.Log.changeset(
            %CheckPoint.Checks.Log{},
            %{action: "test",
              op: nil,
              description: "Test log"}))

    end
    
  end
end
