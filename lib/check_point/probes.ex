defmodule CheckPoint.Probes do
  
  def run_probe(probe, args) do
    apply(CheckPoint.Probes.Probe, probe, [args])
  end

  def to_atom(probe) do
    probe
    |> validate()
    |> String.to_existing_atom()
  end

  @doc """
  Check that probe type is valid
  """
  def validate(probe) do
    if probe in ["http", "green", "red"] do
      probe
    else
      "red"
    end
  end
end

