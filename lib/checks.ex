defmodule CheckPoint.Checks do
  alias CheckPoint.Repo
  alias CheckPoint.Checks.Check

  def list_accounts do
    Repo.all(Check)
  end

  def find_account(%{id: id}) do
    case Repo.get(Check, id) do
      nil -> {:error, "No Check with that id"}
      acc -> {:ok, acc}
    end
  end

  def update_account(id, params) do
    with {:ok, acc} <- find_account(%{id: id}) do
      acc
      |> Check.changeset(params)
      |> Repo.update()
    end
  end

  def create_account(params) do
    %Check{}
    |> Check.changeset(params)
    |> Repo.insert()
  end
end
