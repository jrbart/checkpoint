defmodule CheckPointWeb.Schema.ContactMutation do
  use Absinthe.Schema.Notation

  alias CheckPointWeb.Resolvers

  @desc "Create contacts"
  object :contact_mutations do
    @desc "Create a new contact"
    field :create_contact, :contact do
      arg(:name, :string)
      arg :description, :string
      arg :type, :string
      arg :detail, :string

      resolve &Resolvers.Contact.create/2
    end
  end
end
