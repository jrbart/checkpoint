defmodule CheckPoint.Checks.Contact do
  use Ecto.Schema
  @moduledoc false

  import Ecto.Changeset

  alias CheckPoint.{Checks, Repo}

  schema "contacts" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :detail, :string
    has_many :checks, Checks.Check
  end

  @required_params [:type, :detail]
  @available_params [:name, :description | @required_params]

  def changeset(contact = %Checks.Contact{}, params) do
    contact
    |> Repo.preload(:checks)
    |> cast(params, @available_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
    |> cast_assoc(:checks)
  end

  def create_changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)
end
