defmodule CheckPoint.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Accounts

  schema "accounts" do
    field :name, :string
    field :account, :string
    belongs_to :alert_contact, Accounts.Contact
    many_to_many :contact, Accounts.Contact, join_through: Accounts.AccountsContacts

  end

  @required_params [:name]
  @avalable_params [:account, :alert_contact_id, :contact | @required_params]

  def changeset(account = %CheckPoint.Accounts.Account{}, params) do
    account
      |> cast(params, @avalable_params)
      |> validate_required(@required_params)
    
  end
  

end
