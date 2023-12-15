defmodule CheckPoint.Accounts.AccountsContacts do
  use Ecto.Schema

  alias CheckPoint.Accounts

  schema "accounts_contacts" do
    belongs_to :account, Accounts.Account
    belongs_to :contact, Accounts.Contact
  end
  
  @required_params [:account_id,:contact_id]

  def changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @required_params)
    |> Ecto.Changeset.validate_required(@required_params)
  end
end
