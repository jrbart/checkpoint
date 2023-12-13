defmodule CheckPoint.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Accounts

  schema "accounts" do
    field :name, :string
    field :account, :string
    belongs_to :alert_contact, Accounts.Contact
    many_to_many :contact, Accounts.Contact, join_through: Accounts.AccountContact

  end

  @requied_params [:name]
  @avalable_params @requied_params

  def changeset(account = %CheckPoint.Accounts.Account{}, params) do
    account
      |> cast(params, @avalable_params)
      |> validate_required(@requied_params)
    
  end
  

end
