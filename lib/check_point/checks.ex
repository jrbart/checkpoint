defmodule CheckPoint.Checks do
  alias CheckPoint.Worker
  alias CheckPoint.Checks.{Contact, Check}
  alias EctoShorts.Actions
  @moduledoc false

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    case Actions.find(Contact, Map.put_new(params, :preload, [:checks])) do
      # Add info fields from workers to the result
      {:error, %ErrorMessage{} = err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}

      {:ok, contact} ->
        {:ok,
         contact
         |> Map.update(
           :checks,
           nil,
           &Enum.map(&1, fn ch ->
             Map.put_new(ch, :is_alive, Worker.status(ch.id))
           end)
         )
         |> Map.update(
           :checks,
           nil,
           &Enum.map(&1, fn ch ->
             Map.put_new(ch, :level, Worker.state(ch.id))
           end)
         )}
    end
  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    Actions.create(Contact, params)
  end

  def delete_contact(params) do
    case Actions.delete(Contact, params) do
      {:error, err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}

      res ->
        res
    end
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    with {:ok, check} <- Actions.find(Check, params),
         stat <- Worker.status(check.id),
         state <- Worker.state(check.id) do
      # Add info fields from workers to the result
      {:ok,
       check
       |> Map.put_new(:is_alive, stat)
       |> Map.put_new(:level, state)}
    else
      {:error, err} ->
        {:error, ErrorMessage.to_jsonable_map(err)}
    end
  end

  def create_check(params) do
    # convert action from string to function (atom)
    action =
      params[:action]
      |> CheckPoint.Action.validate()
      |> String.capitalize()
      |> then(fn x -> "Elixir.CheckPoint.Action." <> x end)
      |> String.to_existing_atom()

    args = params[:args]
    # add to database, then if successful, start a worker
    with {:ok, check} <- Actions.create(Check, params),
         {:ok, _pid} <- Worker.run_check(check.id, &action.check/1, args) do
      stat = Worker.status(check.id)
      state = Worker.state(check.id)
      # Add info fields from workers to the result
      {:ok,
       check
       |> Map.put_new(:is_alive, stat)
       |> Map.put_new(:level, state)}
    else
      {:error, err} -> {:error, err}
    end
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    # stop the worker first, then if successful remove from database
    Worker.kill(id)

    with {:error, err} <- Actions.delete(Check, id) do
      {:error, ErrorMessage.to_jsonable_map(err)}
    end
  end
end
