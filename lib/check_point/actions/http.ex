defmodule CheckPoint.Action.Http do
  # alias CheckPoint.Action
  alias Tesla
  @moduledoc """
  Action which issues an HTTP (or HTTPS) request and 
  returns :ok if request was succesful

  iex> Action.Http.check("google.com", "")
  ...> :ok
  """
  def check(addr, _params \\ []) do
    case Tesla.get(addr) do
    {:ok, _resp} -> :ok 
    _ -> false
    end
  end
  
end
