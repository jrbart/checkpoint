defmodule CheckPoint.Checks do
  alias CheckPoint.Worker
  alias CheckPoint.Checks.{Contact,Check}
  alias EctoShorts.Actions

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    with {:ok, contact} <- Actions.find(Contact, params) do
      # For some reason Absinthe gets all discombobulated with %ErrorMessage
      {:ok, contact}
    else 
      {:error, err} -> {:error, Atom.to_string(err.code)}
    end

  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    with {:ok, contact} <- Actions.create(Contact, params) do
      {:ok, contact}
    else 
      {:error, _err} -> {:error, "could not create contact (duplicate?)"}
    end
  end

  def delete_contact(params) do
    with {:ok, contact} <- Actions.delete(Contact,params) do
      {:ok, contact}
    else 
      {:error, err} -> {:error, Atom.to_string(err.code)}
    end
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    with {:ok, check} <- Actions.find(Check, params) do
      {:ok, check}
    else
      {:error, _err} -> {:error, "not found"}
    end
  end

  def create_check(params) do
    action = 
      params[:action]
      |> CheckPoint.Action.validate
      |> String.capitalize
      |> then(fn x -> "Elixir.CheckPoint.Action."<>x end)
      |> String.to_existing_atom
    args = params[:args]
    with {:ok, res} <- Actions.create(Check, params),
         {:ok, pid} = Worker.super_check(res.id, &action.check/1, args)
    do
         stat = Worker.status(pid)
         IO.inspect(stat)
      {:ok, res}
    else
      {:error, _err} -> {:error, "An error occured"}
    end
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    case Actions.delete(Check,id) do
      {:error, _message} -> {:error, "An error occured"}
      res -> res
    end
  end

end
