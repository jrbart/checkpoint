defmodule Mix.Tasks.Seed do
  @moduledoc """
        This task seeds the database with some values
        """
  use Mix.Task
  alias CheckPoint.Checks

  def run(_) do
    Mix.Task.run("app.start")

    Checks.create_contact(%{
        name: "bruce",
        description: "Bruce Boss",
        type: "email",
        detail: "bb@email.com"
      })
    Checks.create_contact(%{
        name: "jeremy",
        description: "Jeremy Walker",
        type: "email",
        detail: "jw@email.com"
      })
    Checks.create_contact(%{
        name: "kristina",
        description: "Kristina Dooright",
        type: "email",
        detail: "cd@email.com"
      })

    Checks.create_check(%{
        description: "Google",
        args: "google.com",
        opts: "",
        contact_id: 3
    })
    Checks.create_check(%{
        description: "localhost",
        args: "localhost",
        opts: "",
        contact_id: 1
    })
    Checks.create_check(%{
        description: "WWW",
        args: "127.0.0.1",
        opts: "delay: 5000",
        contact_id: 1
    })
    Checks.create_check(%{
        description: "SMPT",
        args: "email.com:25",
        opts: "",
        contact_id: 1
    })
  end
end
