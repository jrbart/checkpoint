defmodule CheckPoint.Worker do
  use GenServer, restart: :transient
  require Logger

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok
  then it will log the fact that it ran and its results and sleep for a given duration.
  If it returns :error it will call the Alert moddule which will handle the escalation.
  """
  # API
  @doc """
  Create a checker (GenServer) to repeat a check function.

    iex> {:ok, _pid} = CheckPoint.Worker.check("doctest", fn echo -> echo end, :ok, delay: 5)
  """
@convert_minutes Application.compile_env(:check_point, :convert_minutes)

  def check(name, check_function, args, delay \\ [delay: 10]) do
    # convert delay from min to ms (stays in ms for tests)
    delay_ms = [delay: delay[:delay] * @convert_minutes]
    start_link(name: name, fn: check_function, args: args, opts: delay_ms)
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
    {:noreply, state}
  end

  # call the check function and wait for the results
  @impl true
  def handle_call(_request, _from, state) do
    _name = state[:name]
    check_fn = state[:fn]
    args = state[:args]
    _opts = state[:opts]
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
    opts = state[:opts]
    level = state[:level]

    results =
      check_fn.(args)
      |> CheckPoint.Record.log(name)
      |> CheckPoint.Escalate.alert(name,level)

    # If results is not positive then change timing and start counting
    {time, level} =
      case results do
        :ok -> {opts[:delay], 0}
        :up -> {opts[:delay], 0}
        _ -> {div(opts[:delay], 10), level + 1}
      end


    Process.send_after(self(), :looping, time)
    {:noreply, [{:level, level} | state]}
  end

end
