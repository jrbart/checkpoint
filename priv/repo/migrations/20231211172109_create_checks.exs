defmodule CheckPoint.Repo.Migrations.CreateChecks do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :description, :text
      add :args, :text
      add :opts, :text
      add :account, references(:accounts)
      add :contact, references(:contacts)
    end

  end
end
