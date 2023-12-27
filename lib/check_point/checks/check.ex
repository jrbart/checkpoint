defmodule CheckPoint.Checks.Check do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.{Checks,Repo}

  schema "checks" do
    field :description, :string
    field :action, :string
    field :args, :string
    field :opts, :string
    belongs_to :contact, Checks.Contact
  end

  @required_params [:description, :action]
  @available_params [ :id, :args, :opts, :contact_id | @required_params]

  def changeset(check = %Checks.Check{}, params) do
    check
    |> Repo.preload(:contact)
    |> cast(params, @available_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:contact_id)
    |> cast_assoc(:contact)
  end
  
  def create_changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)
end
