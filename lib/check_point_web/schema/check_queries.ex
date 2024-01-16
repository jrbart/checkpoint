defmodule CheckPointWeb.Schema.CheckQuery do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias CheckPointWeb.Resolvers

  @desc "Get check"
  object :check_queries do
    @desc "Find a check by id"
    field :check, :check do
      arg :id, :id

      resolve &Resolvers.Check.find/2
    end
  end
end
