defmodule CheckPoint.Checks do
  alias CheckPoint.Repo
  alias CheckPoint.Checks.{Contact,Check}

  def list_contacts do
    Repo.all(Contact)
  end

  def find_contact(%{id: id}) do
    case Repo.get(Contact, id) do
      nil -> {:error, "No Contact with that id"}
      acc -> {:ok, acc}
    end
  end

  def update_contact(id, params) do
    with {:ok, contact} <- find_contact(%{id: id}) do
      contact
      |> Contact.changeset(params)
      |> Repo.update()
    end
  end

  def create_contact(params) do
    %Contact{}
    |> Contact.changeset(params)
    |> Repo.insert()
  end

  def list_checks do
    Repo.all(Check)
  end

  def find_check(%{id: id}) do
    case Repo.get(Check, id) do
      nil -> {:error, "No check with that id"}
      acc -> {:ok, acc}
    end
  end

  def update_check(id, params) do
    with {:ok, check} <- find_check(%{id: id}) do
      check
      |> Check.changeset(params)
      |> Repo.update()
    end
  end

  def create_check(params) do
    %Check{}
    |> Check.changeset(params)
    |> Repo.insert()
  end
end
