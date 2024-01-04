defmodule CheckPoint.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias CheckPoint.Repo

      import Ecto
      import Ecto.Query
      import CheckPoint.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CheckPoint.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CheckPoint.Repo, {:shared, self()})
    end

    :ok
  end
end
