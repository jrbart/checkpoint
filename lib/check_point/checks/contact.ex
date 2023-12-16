defmodule CheckPoint.Checks.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  alias CheckPoint.Checks

  schema "contacts" do
      field :name, :string
      field :description, :string
      field :title, :string
      field :type, :string
      field :detail, :string
      has_many :check, Checks.Check
    
  end
  
  @required_params [:type, :details]
  @available_params [:name, :title | @required_params]

  def chamgeset(contact = %CheckPoint.Checks.Contact{}, params) do
    contact
      |> cast(params, @available_params)
      |> validate_required(@required_params)
  end

end
