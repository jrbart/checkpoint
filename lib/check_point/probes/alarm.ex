defmodule CheckPoint.Probes.Alarm do
  use GenServer, restart: :transient
  alias CheckPoint.AlarmReg
  alias CheckPoint.Probes.Notify

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
      {CheckPoint.Probes.Alarm, name: name, fn: fun, args: args}
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
    # start the loop with count=0
    Process.send(self(), :looping, [])
    {:ok, [{:count, 0} | initial]}
  end

  # The main loop will run the probe that was passed in.  If 
  # the result was :ok then the Alarm will ternimate. 
  # Otherwise if it is the third try it will run the Notify
  # handler. Then use send_after to wake up later and repeat.
  # It will continur running and counting until the Alarm is
  # cleared, so when Watcher tries to create an additional 
  # Alarm start_child (above) will just return.
  @impl true
  def handle_info(:looping, state) do
    reply =
      # make a tuple so we can match in case statement instead of nested if
      case {CheckPoint.Probes.run_probe(state[:fn], state[:args]), state[:count]} do
        {:ok, _} ->
          # if the probe comes back up we can stop the alarm
          {:stop, :normal, nil}

        # on 3rd failure do Notify 
        {_, 3} ->
          Notify.notify(state[:name])
          {:noreply, [{:count, state[:count] + 1} | tl(state)]}

        # Otherwise just loop
        _ ->
          {:noreply, [{:count, state[:count] + 1} | tl(state)]}
      end

    Process.send_after(self(), :looping, @convert_minutes)
    reply
  end
end
