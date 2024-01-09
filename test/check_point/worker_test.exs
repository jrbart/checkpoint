defmodule CheckPoint.WorkerTest do
  @moduledoc false
  use ExUnit.Case
  doctest CheckPoint.Worker
  alias CheckPoint.Worker

  # note: in test env delay is ms, in other envs it is minutes
  describe "Worker.check/3" do
    test "can make a Worker" do
      assert Worker.check("exists", fn _ -> :ok end, :ok)
    end

    test "worker takes args" do
      {:ok, pid} = Worker.check("args", fn echo -> echo end, :ok)
      assert :ok === GenServer.call(pid, :ok)
    end
  end
end
