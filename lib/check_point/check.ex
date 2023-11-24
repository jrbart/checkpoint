defmodule CheckPoint.Check do
  # These will eventually be functions that get passed to a task.  The task will 
  # run the function with a set of arguements and record the results.

  @doc """
  Send an ICMP ping to an address
  """
  def ping(_address,_args \\ %{timeout: 5}) do
    rand_ret()
  end

  @doc """
  Check to see if a TCP port is open
  """
  def port(_address,_args \\ %{port: 22}) do
   rand_ret() 
  end

  @doc """
  
  """
  def http(_address,_args \\ %{regex: "OK"}) do
   rand_ret() 
  end



  defp rand_ret do
    Enum.random([:ok, :ok, :error])
  end

end
