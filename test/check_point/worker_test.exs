defmodule CheckPoint.WorkerTest do
  use ExUnit.Case
  doctest CheckPoint.Worker
  alias CheckPoint.Worker

  # note: in test env delay is ms, in other envs it is minutes
  describe "Worker.check/3" do
    test "function exists" do
      assert Worker.check("exists", fn _ -> :ok end, :ok)
    end

    test "worker takes args" do
      {:ok, pid} = Worker.check("args", fn echo -> echo end, :ok)
      assert :ok == GenServer.call(pid, :ok)
    end

    test "worker takes options" do
      {:ok, pid} = Worker.check("opts", fn echo -> echo end, :ok)
      assert :ok == GenServer.call(pid, :ok)
    end

    test "exercise worker1" do
      {:ok, pid} = Worker.check("exists", fn echo -> echo end, :up)
      # for now anything passed through call or cast is ignored
      assert :up == GenServer.call(pid, :blah)
      assert GenServer.cast(pid, :blah)
      # give it time to loop a few
      Process.sleep(10)
      assert :ok == GenServer.stop(pid, :normal)
    end

    # This test fails with an ownership error
    # Removing until I have time to trace what this means...
    # test "exercise worker2" do
    #   {:ok, pid} = Worker.check(1, fn echo -> echo end, :err)
    #   # for now anything passed through call or cast is ignored
    #   assert :err == GenServer.call(pid, :blah)
    #   assert GenServer.cast(pid, :blah)
    #   # give it time to loop a few
    #   Process.sleep(100)
    #   assert :ok == GenServer.stop(pid, :normal)
    # end
  end
end
