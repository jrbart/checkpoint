defmodule CheckPointWeb.Types.Check do
  use Absinthe.Schema.Notation

  @desc "A Check to perform"
  object :check do
    field :id, :id
    field :description, :string
    field :action, :string
    field :args, :string
    field :contact, :contact
    field :is_alive, :string
    field :level, :string

  end
  
end
