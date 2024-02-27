defmodule CheckPointWeb.Types.Check do
  use Absinthe.Schema.Notation
  @moduledoc false

  @desc "A Check to perform"
  object :check do
    field :id, :id
    field :description, :string
    field :probe, :string
    field :args, :string
    field :contact, :contact
  end
end
