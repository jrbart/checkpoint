defmodule CheckPoint.Action do
  alias CheckPoint.Action
  # These will eventually be functions that get passed to a task.  The task will 
  # run the function with a set of arguements and record the results.

  @doc """
        Check that action type is valid

        iex> CheckPoint.Action.validate(:http)
        ...> :ok
        """
  def validate(action) do
    if action in ["http", "green", "red"]
    do
      action
    else
      "red"
    end
  end

  @doc """
       Send an HTTP (or HTTPS) request and seach the reply for a given string
  
  """
  def http(arg, args \\ [regex: "OK"]) do
   Action.Http.check(arg, args) 
  end
end

defmodule CheckPoint.Action.Green do
  
  @doc """
        Always returns :ok

        iex> CheckPoint.Action.Action.Green.check(1)
        ...> :ok
        """
  def check(_), do: :ok
end

defmodule CheckPoint.Action.Red do
  
  @doc """
        Always returns false

        iex> CheckPoint..Action.Red.check(true)
        ...> false
        """
  def check(_), do: false
end
