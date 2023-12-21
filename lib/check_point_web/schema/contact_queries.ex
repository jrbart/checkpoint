defmodule CheckPointWeb.Schema.ContactQuery do
  use Absinthe.Schema.Notation
  import_types CheckPointWeb.Types.Contact
  import_types CheckPointWeb.Types.Check

  alias CheckPointWeb.Resolvers

  @desc "Get contacts"
  object :contact_queries do
    @desc "Find a contact by name"
    field :contact, :contact do
      arg :name, :string

      resolve &Resolvers.Contact.find/2
    end
  end
  
end
