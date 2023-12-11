defmodule CheckPoint.Accounts.Check do
  use Ecto.Schema

  import Ecto.Changeset
    schema "checks" do
      
      field :description, :string
      field :args, :string
      field :opts, :string
      belongs_to :accounts, CheckPoint.Accounts.Check
    end

  @required_params [:description, :args, :opts, :accounts]

  def changeset(check = %CheckPoint.Accounts.Check{}, params) do
    check
      |> cast(params, @required_params)
      |> validate_required(@required_params)
  end
  
end
