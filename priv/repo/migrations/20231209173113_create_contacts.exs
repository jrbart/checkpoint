defmodule CheckPoint.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :text
      add :description, :text
      add :type, :text
      add :detail, :text
    end

  end
end
