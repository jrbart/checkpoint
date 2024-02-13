defmodule CheckPointWeb.Resolvers.Check do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias CheckPoint.{Checks, CheckWatcher}

  def find(%{id: id}, _) do
    case Checks.find_check(%{id: id, preload: :contact}) do
      {:error, _} ->
        {:error, "check not found"}

      res ->
        res
    end
  end

  def create(params, _) do
    case Checks.find_contact(%{name: params.contact}) do
      {:error, _} ->
        {:error, "contact not found"}

      {:ok, cid} ->
        params
        |> Map.delete(:contact)
        |> Map.put(:contact_id, cid.id)
        |> CheckWatcher.create_start()
    end
  end

  def delete(params, _) do
    CheckWatcher.kill_delete(params)
  end
end
