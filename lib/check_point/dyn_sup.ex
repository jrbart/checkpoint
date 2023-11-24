defmodule CheckPoint.DynSup do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  def start_link(init_arg) do
    # IO.inspect(init_arg, label: __MODULE__)
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
