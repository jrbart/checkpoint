defmodule CheckPoint.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :text
      add :title, :text
      add :type, :text
      add :details, :text
    end

  end
end
