defmodule CheckPoint.EscalateTest do
  @moduledoc false
  use ExUnit.Case
  doctest CheckPoint.Escalate
  alias CheckPoint.Escalate

  describe "CheckPoint.Escalate.alert/" do
    test "arg passes through" do
      for res <- [:ok, :up, :error],
          do: assert(Escalate.alert(res, "test", 0) == res)
    end
  end
end
