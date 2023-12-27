defmodule CheckPoint.Check do
  alias CheckPoint.Action
  # These will eventually be functions that get passed to a task.  The task will 
  # run the function with a set of arguements and record the results.

  @doc """
        Check that action type is valid

        iex> CheckPoint.Check.validate(:ping)
        ...> :ok
        """
  def validate(action)
  def validate(action) when action in [:http, :green, :red], do: :ok
  def validate(_), do: false


  @doc """
       Send an HTTP (or HTTPS) request and seach the reply for a given string
  
  """
  def http(arg, args \\ [regex: "OK"]) do
   Action.Http.check(arg, args) 
  end


  @doc """
        Always returns :ok

        iex> CheckPoint.Check.green(1)
        ...> :ok
        """
  def green(_), do: :ok

  @doc """
        Always returns false

        iex> CheckPoint.Check.red(true)
        ...> false
        """
  def red(_), do: false
end
