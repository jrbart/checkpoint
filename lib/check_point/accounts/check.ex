defmodule CheckPoint.Accounts.Check do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Accounts

  schema "checks" do
    field :description, :string
    field :args, :string
    field :opts, :string
    belongs_to :account, CheckPoint.Accounts.Account
    belongs_to :contact, Accounts.Contact
  end

  @required_params [:description, :args, :opts, :account_id]
  @available_params [:contact_id | @required_params]

  def changeset(check = %CheckPoint.Accounts.Check{}, params) do
    check
    |> cast(params, @available_params)
    |> validate_required(@required_params)
  end
end
