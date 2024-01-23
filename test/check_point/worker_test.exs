defmodule CheckPoint.WatcherTest do
  @moduledoc false
  use ExUnit.Case
  alias CheckPoint.Watcher

  # note: in test env delay is ms, in other envs it is minutes
  describe "Watcher.check/3" do
    test "can make a Watcher" do
      assert Watcher.check(999, :red, :ok)
    end
  end
end
