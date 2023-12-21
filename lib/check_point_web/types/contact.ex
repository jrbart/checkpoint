defmodule CheckPointWeb.Types.Contact do
  use Absinthe.Schema.Notation
  # import Absinthe.Resolution.Helpers
  @desc "A Contact"
  object :contact do
    field :id, :id
    field :name, :string
    field :description, :string
    field :type, :string
    field :detail, :string

  end
  
end
