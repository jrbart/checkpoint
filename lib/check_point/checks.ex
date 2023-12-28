defmodule CheckPoint.Checks do
  alias CheckPoint.Worker
  alias CheckPoint.Checks.{Contact,Check}
  alias EctoShorts.Actions

  def list_contacts(params \\ %{}) do
    Actions.all(Contact, params)
  end

  def find_contact(params) do
    case Actions.find(Contact, params) do
      # For some reason Absinthe gets all discombobulated with %ErrorMessage
      {:error, _message} -> {:error, "An error occured"}
      res -> res
    end
  end

  def update_contact(id, params) do
    Actions.update(Contact, id, params)
  end

  def create_contact(params) do
    case Actions.create(Contact, params) do
      {:error, _message} -> {:error, "An error occured"}
      res -> res
    end
  end

  def delete_contact(params) do
    case Actions.delete(Contact,params) do
      {:error, _message} -> {:error, "An error occured"}
      res -> res
    end
  end

  def list_checks(params \\ %{}) do
    Actions.all(Check, params)
  end

  def find_check(params) do
    case Actions.find(Check, params) do
      # For some reason Absinthe gets all discombobulated with %ErrorMessage
      {:error, _message} -> {:error, "An error occured"}
      res -> res
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
    delay_str = params[:opts]
    delay = to_kv(delay_str)
    case Actions.create(Check, params) do
      {:error, _message} -> {:error, "An error occured"}
      {:ok, res} -> Worker.check(res.id,&action.check/1, args, delay) |> IO.inspect; {:ok, res}
    end
  end

  def delete_check(%{id: id}) do
    id = String.to_integer(id)
    case Actions.delete(Check,id) do
      {:error, _message} -> {:error, "An error occured"}
      res -> res
    end
  end

  # for now kv is just "delay: xx" or ""
  # Eventually this need to convert arbitrary kv strings to lists
  def to_kv(str) do
     case String.split(str, " ") do
       [_k,v] -> [delay: String.to_integer(v)] 
      _ -> [delay: 5]
     end
  end
end
