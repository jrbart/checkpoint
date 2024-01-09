defmodule CheckPoint.Action do
  alias CheckPoint.Action
  # These are functions that get passed to a task.  The task will 
  # run the function with a set of arguements and record the results.
  @moduledoc false

  @doc """
  Check that action type is valid
  """
  def validate(action) do
    if action in ["http", "green", "red"] do
      action
    else
      "red"
    end
  end

  @doc """
       Send an HTTP (or HTTPS) request and check that it succeeded
  """
  def http(arg, args \\ [regex: "OK"]) do
    Action.Http.check(arg, args)
  end
end

defmodule CheckPoint.Action.Green do
  @moduledoc false
  @doc """
  Always returns :ok
  """
  def check(_), do: :ok
end

defmodule CheckPoint.Action.Red do
  @moduledoc false
  @doc """
  Always returns false
  """
  def check(_), do: false
end
