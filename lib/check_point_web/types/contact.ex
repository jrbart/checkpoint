defmodule CheckPointWeb.Types.Contact do
  use Absinthe.Schema.Notation

  @desc "A Contact"
  object :contact do
    field :id, :id
    field :name, :string
    field :description, :string
    field :type, :string
    field :detail, :string
    field :checks, list_of(:check)

  end
  
end
