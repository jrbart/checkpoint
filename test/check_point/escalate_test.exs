defmodule CheckPoint.EscalateTest do
  use ExUnit.Case
  doctest CheckPoint.Escalate
  alias CheckPoint.Escalate

  describe "CheckPoint.Escalate.alert/" do

    test "arg passes through" do
      for res <- [:ok, :up, :error],
        do: assert(Escalate.alert(res, "test", 0) == res)
    end

    test "no alerts on levels 0-4,6-" do
    #   # for level <- [],
    #   #   do: nil # assert(Escalate.alert(:err, "test", level)
    end

    test "does alert on level 5" do
    #   # for res <- [:ok, :up, :error],
    #   #     do: nil # assert(Escalate.alert(res, "test", 0) == res)
    end

  end

end
