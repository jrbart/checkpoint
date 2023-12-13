defmodule CheckPoint.Repo.Migrations.CreateAccountContact do
  use Ecto.Migration

  def change do
    create table(:account_contact) do
      add(:account, references(:accounts))
      add(:contact, references(:contacts))
    end
  end
end
