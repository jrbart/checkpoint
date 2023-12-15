defmodule CheckPoint.Repo.Migrations.CreateAccountContact do
  use Ecto.Migration

  def change do
    create table(:accounts_contacts) do
      add(:account_id, references(:accounts))
      add(:contact_id, references(:contacts))
    end
  end
end
