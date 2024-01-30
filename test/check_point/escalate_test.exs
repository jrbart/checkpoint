defmodule CheckPoint.NotifyTest do
  @moduledoc false
  use ExUnit.Case
  doctest CheckPoint.Notify
  alias CheckPoint.Notify

  describe "&CheckPoint.Notify.notify/3" do
    test "arg passes through" do
      for res <- [:ok, :error],
          do: assert(Notify.maybe_notify(res, 0, 0) === res)
    end
  end
end
