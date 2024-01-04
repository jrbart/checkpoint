defmodule CheckPoint.Checks do
  alias CheckPoint.Worker
  alias CheckPoint.Checks.{Contact,Check}
  alias EctoShorts.Actions

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    # Absinthe gets all discombobulated with %ErrorMessage
    # So I'm handling error from EctoShorts using 'with' macros
    with {:ok, contact} <- Actions.find(Contact, Map.put_new(params,:preload, [:checks])) do
      # Add info fields from workers to the result
      contact = Map.put(contact, :checks, 
        for ch <- contact.checks do 
          Map.put_new(ch, :is_alive, Worker.status(ch.id))
        end
      )
      contact = Map.put(contact, :checks, 
        for ch <- contact.checks do 
          Map.put_new(ch, :level, Worker.state(ch.id))
        end
      )
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
      # Add info fields from workers to the result
      stat = Worker.status(check.id)
      check = Map.put_new(check, :is_alive, stat)
      state = Worker.state(check.id)
      check = Map.put_new(check, :level, state)
      {:ok, check}
    else
      {:error, _err} -> {:error, "not found"}
    end
  end

  def create_check(params) do
    # convert action from string to function (atom)
    action = 
      params[:action]
      |> CheckPoint.Action.validate
      |> String.capitalize
      |> then(fn x -> "Elixir.CheckPoint.Action."<>x end)
      |> String.to_existing_atom
    args = params[:args]
    # add to database, then if successful, start a worker
    with {:ok, res} <- Actions.create(Check, params),
         {:ok, pid} = Worker.super_check(res.id, &action.check/1, args)
    do
         # Add info fields from workers to the result
         stat = Worker.status(pid)
         res = Map.put_new(res, :is_alive, stat)
         state = Worker.state(pid)
         res = Map.put_new(res, :level, state)
      {:ok, res}
    else
      {:error, _err} -> {:error, "An error occured creating check"}
    end
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    # stop the worker first, then if successful remove from database
    Worker.kill(id)
    case Actions.delete(Check,id) do
      {:error, _message} -> {:error, "An error occured deleitng check"}
      res -> res
    end
  end

end
