defmodule CheckPoint.AlertTest do
  @moduledoc false
  use ExUnit.Case
  doctest CheckPoint.Alert
  alias CheckPoint.Alert

  describe "&CheckPoint.Alert.alert/3" do
    test "arg passes through" do
      for res <- [:ok, :error],
          do: assert(Alert.maybe_alert(res, 0, 0) === res)
    end
  end
end
