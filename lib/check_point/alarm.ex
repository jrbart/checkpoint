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
    DynamicSupervisor.start_child(
      CheckPoint.AlarmSup,
      {CheckPoint.Alarm, name: name, fn: fun, args: args}
    )
  end

  @doc """
  looks up genserver by id and removes it
  """
  def kill(id) do
    {pid, _} = hd(Registry.lookup(AlarmReg, id))
    GenServer.stop(pid, :normal)
  end

  # Implementation

  def start_link(initial) do
    name = {:via, Registry, {CheckPoint.AlarmReg, initial[:name]}}
    GenServer.start_link(__MODULE__, initial, name: name)
  end

  # the initialization showld quckly return so the engine can move on 
  @impl true
  def init(initial) do
    # start the loop with level=0
    Process.send(self(), :looping, [])
    {:ok, [{:level, 0} | initial]}
  end

  # this is the main loop
  # the main loop will run the check funtion that was passed
  # in.  If the result was :ok then the Alarm will stop. 
  # Otherwise it will run the Notify handler to maybe send
  # an Notify then use send_after to wake up later and repeat
  @impl true
  def handle_info(:looping, state) do
    # apply check_fn to args and pass to Notify
    results =
      state[:args]
      |> then(fn args ->
        apply(CheckPoint.Probe, state[:fn], [args])
      end)
      |> CheckPoint.Notify.maybe_notify(state[:name], state[:level])

    # If results is not :ok then start counting
    case results do
      :ok ->
        # if the probe comes back up we can stop the alarm
        {:stop, :normal, nil}

      _ ->
        Process.send_after(self(), :looping, @convert_minutes)
        # Each time the level increases so we can notify after a numnber of failures
        {:noreply, [{:level, state[:level] + 1} | tl(state)]}
    end
  end
end
