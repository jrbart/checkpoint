defmodule CheckPoint.Repo.Migrations.CreateChecks do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :description, :text
      add :args, :text
      add :opts, :text
      add :contact_id, references(:contacts), null: :false
    end

  end
end
