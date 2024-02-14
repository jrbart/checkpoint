defmodule CheckPoint.Probes.Watcher do
  use GenServer, restart: :transient
  alias CheckPoint.Probes
  alias CheckPoint.Probes.Alarm

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok then
  it will sleep for a given duration. If it returns anything else it will call the Alarm 
  moddule which will handle the escalation.
  """

  # API

  @convert_minutes Application.compile_env(:check_point, :convert_minutes)

  @doc """
  start a supervised worker to run fn with args and wait delay between loops
  """
  def start_watcher(name, fun, args) do
    case DynamicSupervisor.start_child(
           CheckPoint.WatchSup,
           {CheckPoint.Probes.Watcher, name: name, fn: fun, args: args}
         ) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, err} ->
        {:error, ErrorMessage.internal_server_error("Check id #{name}", %{error: err})}
    end
  end

  @doc """
  looks up worker by id and removes it
  """
  def kill(id) do
    GenServer.stop({:via, Registry, {CheckPoint.WatcherReg, id}}, :normal)
  end

  # Implementation
  # if a Watcher already exists with the same name it will just return
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

  # The main loop will run the probe that was passed
  # in.  If the result was anything beside :ok it will
  # create an Alarm. Either way it will use send_after 
  # to wake up later and repeat
  @impl true
  def handle_info(:looping, state) do
    # If probe is not :ok then create an Alarm
    case Probes.run_probe(state[:fn], [state[:args]]) do
      :ok -> nil
      _ -> Alarm.create_alarm(state[:name], state[:fn], state[:args])
    end

    Process.send_after(self(), :looping, 3 * @convert_minutes)
    {:noreply, state}
  end
end
