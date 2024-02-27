defmodule CheckPointWeb.Resolvers.Check do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias CheckPoint.{Checks, CheckWatcher}

  # For now checks are reference by their :id.  This is not very intuitive
  # We probably want to allow them to be named, but that name would have to
  # be unique to the contact, and the we would need to pass in all parts of 
  # the unique key on every find.  Possibly even add in the probe as part 
  # of the uniqueness so that there could be multiple probes that are 
  # checking different aspects of a service (once more probe types are
  # added).  
  # Also, since there is only one contact allowed per check, the preload
  # here does not impose a burden on the database lookup.
  def find(%{id: id}, _) do
    case Checks.find_check(%{id: id, preload: :contact}) do
      {:ok, _ } = res ->
        res


      _ -> 
        {:error, "Check not found"}
    end
  end

  # We could allow the foreign constraint on the contact :name to be the
  # reference here and then a failure would occur at a database level
  # when an insert is done but there is no matching contact :name but
  # would PG be able to fill in the :id somehow?  Other option is to
  # remove the contact :id and only use the contact :name which is
  # fine in theory but it could cause confusion for someone who is 
  # less versed in SQL.
  def create(params, _) do
    case Checks.find_contact(%{name: params.contact}) do
      {:ok, contact} ->
        params
        |> Map.delete(:contact)
        |> Map.put(:contact_id, contact.id)
        |> CheckWatcher.create_start()

      _ ->
        {:error, "Contact name not valid"}
    end
  end

  def delete(params, _) do
    CheckWatcher.kill_delete(params)
  end
end
