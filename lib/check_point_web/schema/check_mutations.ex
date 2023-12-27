defmodule CheckPointWeb.Schema.CheckMutation do
  use Absinthe.Schema.Notation

  alias CheckPointWeb.Resolvers

  @desc "Change a check"
  object :check_mutations do
    @desc "Create a new check"
    field :create_check, :check do
      arg :description, :string
      arg :action, :string
      arg :args, :string
      arg :opts, :string
      arg :contact, :string

      resolve &Resolvers.Check.create/2
    end

    @desc "Delete a check"
    field :delete_check, :check do
      arg :id, non_null(:id)

      resolve &Resolvers.Check.delete/2
    end
  end
  
end
