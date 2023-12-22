defmodule CheckPointWeb.Schema.ContactQuery do
  use Absinthe.Schema.Notation

  alias CheckPointWeb.Resolvers

  @desc "Get contact"
  object :contact_queries do
    @desc "Find a contact by name"
    field :contact, :contact do
      arg(:name, :string)

      resolve(&Resolvers.Contact.find/2)
    end
  end
end
