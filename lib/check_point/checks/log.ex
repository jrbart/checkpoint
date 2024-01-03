defmodule CheckPoint.Checks.Log do
  use Ecto.Schema
  alias CheckPoint.Checks

  import Ecto.Changeset

  schema "logs" do
      field :action, :string
      field :op, :integer
      field :description, :string

    timestamps()
  end
  
  @required_params [:action]
  @available_params [:op, :description | @required_params]

  def changeset(log = %Checks.Log{}, params) do
    log
    |> cast(params, @available_params)
    |> validate_required(@required_params)

  end

  def create_changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)
end
