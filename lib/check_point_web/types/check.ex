defmodule CheckPointWeb.Types.Check do
  use Absinthe.Schema.Notation
  # import Absinthe.Resolution.Helpers
  @desc "A Check to perform"
  object :check do
    field :id, :id
    field :description, :string
    field :args, :string
    field :opts, :string
    field :contact, :contact

  end
  
end
