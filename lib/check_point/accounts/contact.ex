defmodule CheckPoint.Accounts.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Accounts

  schema "contacts" do
      field :name, :string
      field :description, :string
      field :title, :string
      field :type, :string
      field :detail, :string
      many_to_many :account, Accounts.Account, join_through: Accounts.AccountContact
      has_many :check, Accounts.Check
    
  end
  
  @required_params [:type, :details]
  @available_params [:name, :title | @required_params]

  def chamgeset(contact = %CheckPoint.Accounts.Contact{}, params) do
    contact
      |> cast(params, @available_params)
      |> validate_required(@required_params)
  end

end
