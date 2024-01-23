defmodule CheckPoint.Service do
  # These are functions that get passed to a task.  The task will 
  # run the function with a set of arguements and set an Alarm if 
  # the results is not :ok
  @moduledoc false

  @doc """
  Check that service type is valid
  """
  def validate(service) do
    if service in ["http", "green", "red"] do
      service
    else
      "red"
    end
  end

  @doc """
       Send an HTTP (or HTTPS) GET request and check that it succeeded
  """
  def http(addr, _args \\ []) do
    alias Tesla

    case Tesla.get(addr) do
      {:ok, _resp} -> :ok
      _ -> false
    end
  end

  @doc """
  Always returns :ok
  """
  def green(_), do: :ok

  @doc """
  Always returns false
  """
  def red(_), do: false
end
