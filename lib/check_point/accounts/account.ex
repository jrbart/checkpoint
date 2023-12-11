defmodule CheckPoint.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    belongs_to :alert_contact, CheckPoint.Accounts.Contact
    has_many :contacts, CheckPoint.Accounts.Contact

  end

  @requied_params [:name]
  @avalable_params @requied_params

  def changeset(account = %CheckPoint.Accounts.Account{}, params) do
    account
      |> cast(params, @avalable_params)
      |> validate_required(@requied_params)
    
  end
  

end
