defmodule CheckPoint.Worker do
  use GenServer, restart: :transient
  alias CheckPoint.WorkerReg
  require Logger

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok
  then it will log the fact that it ran and its results and sleep for a given duration.
  If it returns :error it will call the Alert moddule which will handle the escalation.
  """
  # API
@convert_minutes Application.compile_env(:check_point, :convert_minutes)

  @doc """
        super_check(name, fn, args)
        start a supervised worker to run fn with args and wait delay between loops
        """
  def super_check(name, fun, args) do
    DynamicSupervisor.start_child(
      CheckPoint.DynSup,
      {CheckPoint.Worker, name: name, fn: fun, args: args}
    )
  end

  @doc """
        status(id || pid)
        return running status of genserver
        """
  def status(pid) when is_pid(pid), do: Enum.at(elem(:sys.get_status(pid),3),1)
  def status(id) when is_integer(id) do
    case Registry.lookup(WorkerReg, id) do
      [{pid, _} | _] -> status(pid)
      _ -> "not in Registry"
    end
  end
  def status(_), do: "unkown worker id"
  @doc """
        state(id || pid)
        """
  def state(pid) when is_pid(pid), do: :sys.get_state(pid)[:level]
  def state(id) when is_integer(id) do
    case Registry.lookup(WorkerReg, id) do
      [{pid, _} | _] -> state(pid)
      _ -> "not in Registry"
    end
  end
  def state(_), do: "unknow worker id"
  @doc """
        kill(id)
        looks up worker by id and removes it
        """
  def kill(id) do
    with {pid, _} <- hd(Registry.lookup(WorkerReg,id)) do
      GenServer.stop(pid, :normal)
    end
  :ok
  end

  @doc """
  Create a checker (GenServer) to repeat a check function.

    iex> {:ok, _pid} = CheckPoint.Worker.check("doctest", fn echo -> echo end, :ok)
  """
  def check(name, check_function, args) do
    # convert delay from min to ms (stays in ms for tests)
    start_link(name: name, fn: check_function, args: args)
  end

  def start_link(initial) do
    name = {:via, Registry, {CheckPoint.WorkerReg, initial[:name]}}
    GenServer.start_link(__MODULE__, initial, name: name)
  end

  # the initialization showld quckly return so the engine can move on to 
  # initializing the rest of the checks.
  @impl true
  def init(initial) do
    state = [{:level, 0} | initial]
    {:ok, state, {:continue, :start}}
  end

  # continue with any setup that needs to be done on init
  @impl true
  def handle_continue(_continue_arg, state) do
    # start the loop
    Process.send(self(), :looping, [])
    {:noreply, state}
  end

  # call the check function and wait for the results
  @impl true
  def handle_call(_request, _from, state) do
    check_fn = state[:fn]
    args = state[:args]
    reply = check_fn.(args)
    {:reply, reply, state}
  end

  @impl true
  def handle_cast(_request, state) do
    # start the loop
    Process.send(self(), :looping, [])
    {:noreply, state}
  end

  # this is the main loop
  # the main loop will run the check funtion that was passed
  # in and record the result.  Then if the result was not :ok
  # it should notify the alert handler.  If everything was ok
  # then it should send_after to wake up later
  @impl true
  def handle_info(:looping, state) do
    Logger.info("Looping...")
    name = state[:name]
    check_fn = state[:fn]
    args = state[:args]
    level = state[:level]

    results =
      check_fn.(args)
      |> CheckPoint.Record.log(name)
      |> CheckPoint.Escalate.alert(name,level)

    # If results is not :ok or :up then shorten timing and start counting
    {time, level} =
      case results do
        :ok -> {3*@convert_minutes, 0}
        :up -> {3*@convert_minutes, 0}
        _ -> {@convert_minutes, level + 1}
      end


    Process.send_after(self(), :looping, time)
    {:noreply, [{:level, level} | tl(state)]}
  end

end
