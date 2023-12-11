defmodule CheckPoint.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :text
      add :alert_contact, references(:contacts)
    end

  end
end
