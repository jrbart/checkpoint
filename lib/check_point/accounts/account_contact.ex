defmodule CheckPoint.Accounts.AccountContact do
  use Ecto.Schema

  alias CheckPoint.Accounts

  schema "account_contact" do
    belongs_to :account, Accounts.Account
    belongs_to :contact, Accounts.Contact
  end
  
end
