defmodule CheckPoint.Checks.Check do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Checks

  schema "checks" do
    field :description, :string
    field :args, :string
    field :opts, :string
    belongs_to :contact, Checks.Contact
  end

  @required_params [:description, :args, :opts, :contact_id]
  @available_params [:contact_id | @required_params]

  def changeset(check = %CheckPoint.Checks.Check{}, params) do
    check
    |> cast(params, @available_params)
    |> validate_required(@required_params)
  end
end
