defmodule CheckPointWeb.Schema do
  use Absinthe.Schema

  import_types CheckPointWeb.Schema.ContactQuery
  # import_types CheckPointWeb.Schema.ContactSubscription
  import_types CheckPointWeb.Schema.ContactMutation
  import_types CheckPointWeb.Schema.CheckQuery
  # import_types CheckPointWeb.Schema.CheckSubscription
  # import_types CheckPointWeb.Schema.CheckMutation
  import_types CheckPointWeb.Types.Check
  import_types CheckPointWeb.Types.Contact
  
  query do
    import_fields :contact_queries
    import_fields :check_queries
  end

  mutation do
    import_fields :contact_mutations
  end

  # subscription do
  #   import_fields :contact_mutations
  # end
end
