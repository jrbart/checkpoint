defmodule CheckPoint.Checks.Check do
  use Ecto.Schema
  @moduledoc false

  import Ecto.Changeset

  alias CheckPoint.Checks

  schema "checks" do
    field :description, :string
    field :service, :string
    field :args, :string
    belongs_to :contact, Checks.Contact
  end

  @required_params [:description, :service]
  @available_params [:id, :args, :contact_id | @required_params]

  def changeset(check = %Checks.Check{}, params) do
    check
    |> cast(params, @available_params)
    |> cast_assoc(:contact)
    |> validate_required(@required_params)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end
end
