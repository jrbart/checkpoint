defmodule CheckPoint.Watcher do
  use GenServer, restart: :transient
  alias CheckPoint.WatcherReg

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok
  then it will log the fact that it ran and its results and sleep for a given duration.
  If it returns :error it will call the Alert moddule which will handle the escalation.
  """

  # API

  @convert_minutes Application.compile_env(:check_point, :convert_minutes)

  @doc """
  start a supervised worker to run fn with args and wait delay between loops
  """
  def start_watcher(name, fun, args) do
    case DynamicSupervisor.start_child(
           CheckPoint.WatchSup,
           {CheckPoint.Watcher, name: name, fn: fun, args: args}
         ) do
      {:ok, pid} -> {:ok, pid}
      {:error, err} -> {:error, ErrorMessage.not_found("Check id #{name}", %{error: err})}
    end
  end

  @doc """
  looks up worker by id and removes it
  """
  def kill(id) do
    {pid, _} = hd(Registry.lookup(WatcherReg, id))
    GenServer.stop(pid, :normal)
  end

  @doc """
  Create a checker (GenServer) to repeat a check function.
  """
  def check(name, check_function, args) do
    # convert delay from min to ms (stays in ms for tests)
    start_link(name: name, fn: check_function, args: args)
  end

  # Implementation

  def start_link(initial) do
    name = {:via, Registry, {CheckPoint.WatcherReg, initial[:name]}}
    GenServer.start_link(__MODULE__, initial, name: name)
  end

  # the initialization showld quckly return so the engine can move on to 
  # initializing the rest of the checks.
  @impl true
  def init(initial) do
    # start the loop
    Process.send(self(), :looping, [])
    {:ok, initial}
  end

  # this is the main loop
  # the main loop will run the check funtion that was passed
  # in.  Then if the result was anything beside :ok it will
  # create and Alarm. Either way it will use send_after to
  # wake up later and repeat
  @impl true
  def handle_info(:looping, state) do
    # If probe is not :ok then create an Alarm
    case apply(CheckPoint.Probe, state[:fn], [state[:args]]) do
      :ok -> :ok
      _ -> CheckPoint.Alarm.create_alarm(state[:name], state[:fn], state[:args])
    end

    Process.send_after(self(), :looping, 3 * @convert_minutes)
    {:noreply, state}
  end
end
