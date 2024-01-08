defmodule CheckPoint.Checks.Check do
  use Ecto.Schema
  @moduledoc false

  import Ecto.Changeset

  alias CheckPoint.{Checks, Repo}

  schema "checks" do
    field(:description, :string)
    field(:action, :string)
    field(:args, :string)
    belongs_to(:contact, Checks.Contact)
  end

  @required_params [:description, :action]
  @available_params [:id, :args, :contact_id | @required_params]

  def changeset(check = %Checks.Check{}, params) do
    check
    |> Repo.preload(:contact)
    |> cast(params, @available_params)
    # |> foreign_key_constraint(:contact_id)
    |> cast_assoc(:contact)
    |> validate_required(@required_params)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
    # one or the other is reqired but how to validate that?
    # |> validate_required([:contact_id])
    # |> validate_required([:contact])
  end
end
