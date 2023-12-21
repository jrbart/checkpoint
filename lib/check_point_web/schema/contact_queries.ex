defmodule CheckPointWeb.Schema.ContactQuery do
  use Absinthe.Schema.Notation
  alias CheckPointWeb.Resolvers

  object :contact do
    field :name, :string
    field :description, :string
    field :type, :string
    field :detail, :string
  end

  @desc "Get contacts"
  object :contact_queries do
    @desc "Find a contact by name"
    field :contact, :contact do
      arg :name, :string

      resolve &Resolvers.Contact.find/2
    end
  end
  
end
