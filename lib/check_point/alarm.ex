defmodule CheckPoint.Alarm do
  use GenServer, restart: :transient
  alias CheckPoint.AlarmReg

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok
  then it will log the fact that it ran and its results and sleep for a given duration.
  If it returns :error it will call the Alert moddule which will handle the escalation.
  """

  # API
  # When checking an alarm, check 10 times faster than a Watch would
  @convert_minutes div(Application.compile_env(:check_point, :convert_minutes), 10)

  @doc """
  start a supervised worker to run fn with args and wait delay between loops
  """
  def create_alarm(name, fun, args) do
    with {:ok, pid} <-
           DynamicSupervisor.start_child(
             CheckPoint.AlarmSup,
             {CheckPoint.Alarm, name: name, fn: fun, args: args}
           ) do
      {:ok, pid}
    else
      {:error, err} -> {:error, ErrorMessage.not_found("Alarm id #{name}", %{error: err})}
    end
  end

  @doc """
  return running status of genserver
  """
  def status(pid) when is_pid(pid), do: Enum.at(elem(:sys.get_status(pid), 3), 1)

  def status(id) when is_integer(id) do
    case Registry.lookup(AlarmReg, id) do
      [{pid, _} | _] -> status(pid)
      _ -> "not in Registry"
    end
  end

  def status(_), do: "unkown alarm id"

  def state(pid) when is_pid(pid), do: :sys.get_state(pid)[:level]

  def state(id) when is_integer(id) do
    case Registry.lookup(AlarmReg, id) do
      [{pid, _} | _] -> state(pid)
      _ -> "not in Registry"
    end
  end

  def state(_), do: "unknow alarm id"

  @doc """
  looks up worker by id and removes it
  """
  def kill(id) do
    with {pid, _} <- hd(Registry.lookup(AlarmReg, id)) do
      GenServer.stop(pid, :normal)
    end

    :ok
  end

  @doc """
  Create a Alarm (GenServer)
  """
  def check(name, check_function, args) do
    # convert delay from min to ms (stays in ms for tests)
    start_link(name: name, fn: check_function, args: args)
  end

  # Implementation

  def start_link(initial) do
    name = {:via, Registry, {CheckPoint.AlarmReg, initial[:name]}}
    GenServer.start_link(__MODULE__, initial, name: name)
  end

  # the initialization showld quckly return so the engine can move on to 
  # initializing the rest of the checks.
  @impl true
  def init(initial) do
    state = [{:level, 0} | initial]

    # start the loop
    Process.send(self(), :looping, [])
    {:ok, state}
  end

  # this is the main loop
  # the main loop will run the check funtion that was passed
  # in.  Then if the result was anything beside :ok or :up
  # it should will the alert handler.
  # Then it will use send_after to wake up later and repeat
  @impl true
  def handle_info(:looping, state) do
    name = state[:name]
    check_fn = state[:fn]
    args = state[:args]
    level = state[:level]

    # apply check_fn to args and pass to alert
    results =
      args
      |> then(fn args -> apply(CheckPoint.Service, check_fn, [args]) end)
      |> CheckPoint.Alert.alert(name, level)

    # If results is not :ok then start counting
    # later this delay will be configurable
    case results do
      :ok ->
        {:stop, :normal, nil}

      _ ->
        Process.send_after(self(), :looping, @convert_minutes)
        {:noreply, [{:level, level + 1} | tl(state)]}
    end
  end
end
