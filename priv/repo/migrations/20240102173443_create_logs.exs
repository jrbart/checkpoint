defmodule CheckPoint.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table("logs") do
      add :action, :text
      add :op, :integer
      add :description, :text
      timestamps()
    end

  end
end
