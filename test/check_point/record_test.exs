defmodule CheckPoint.RecordTest do
  use ExUnit.Case
  doctest CheckPoint.Record
  alias CheckPoint.Record

  describe "Check.log/1" do
    test "arg passed through" do
      for res <- [:ok, :up, :error],
        do: assert Record.log(res, "test") == res
    end
  end
end
