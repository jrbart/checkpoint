defmodule CheckPoint.Alarm do
  use GenServer, restart: :transient
  alias CheckPoint.AlarmReg

  @moduledoc """
  Each Alarm runs a checkpoint function in a genserver.  If the function returns :ok
  then it will stop the Alarm.  If it returns :error it will call the Notify moddule 
  which will handle the escalation.
  """

  # API
  # When checking an alarm, check every minute
  @convert_minutes Application.compile_env(:check_point, :convert_minutes)

  @doc """
  start a supervised worker to run fn with args and wait between loops
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
  looks up genserver by id and removes it
  """
  def kill(id) do
    with {pid, _} <- hd(Registry.lookup(AlarmReg, id)) do
      GenServer.stop(pid, :normal)
    end

    :ok
  end

  # Implementation

  def start_link(initial) do
    name = {:via, Registry, {CheckPoint.AlarmReg, initial[:name]}}
    GenServer.start_link(__MODULE__, initial, name: name)
  end

  # the initialization showld quckly return so the engine can move on 
  @impl true
  def init(initial) do
    state = [{:level, 0} | initial]

    # start the loop
    Process.send(self(), :looping, [])
    {:ok, state}
  end

  # this is the main loop
  # the main loop will run the check funtion that was passed
  # in.  If the result was :ok then the Alarm will stop. 
  # Otherwise it will run the Notify handler to maybe send
  # an Notify then use send_after to wake up later and repeat
  @impl true
  def handle_info(:looping, state) do
    name = state[:name]
    check_fn = state[:fn]
    args = state[:args]
    level = state[:level]

    # apply check_fn to args and pass to Notify
    results =
      args
      |> then(fn args -> apply(CheckPoint.Service, check_fn, [args]) end)
      |> CheckPoint.Notify.maybe_notify(name, level)

    # If results is not :ok then start counting
    case results do
      :ok ->
        {:stop, :normal, nil}

      _ ->
        Process.send_after(self(), :looping, @convert_minutes)
        {:noreply, [{:level, level + 1} | tl(state)]}
    end
  end
end
