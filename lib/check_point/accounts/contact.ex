defmodule CheckPoint.Accounts.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  schema "contacts" do
      field :name, :string
      field :title, :string
      field :type, :string
      field :details, :string
      belongs_to :account, CheckPoint.Accounts.Account
    
  end
  
  @required_params [:type, :details]
  @available_params [:name, :title | @required_params]

  def chamgeset(contact = %CheckPoint.Accounts.Contact{}, params) do
    contact
      |> cast(params, @available_params)
      |> validate_required(@required_params)
  end

end
