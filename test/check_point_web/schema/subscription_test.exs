defmodule CheckPointWeb.Schema.SubscriptionTest do
  use CheckPointWeb.SubscriptionCase
  use CheckPoint.RepoCase

  alias CheckPoint.CheckWatcher

  describe "subscription" do
    test "triggers check_notify when notify occurs", %{socket: socket} do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }

      {:ok, check} =
        CheckWatcher.create_start(%{
          description: "test",
          probe: "red",
          args: "test",
          contact: contact
        })

      sub = "subscription { checkNotify( id: \"#{check.id}\" ) { id }}"
      ref = push_doc(socket, sub)

      # Because timing is fast, might have to skip this assert
      assert_reply(ref, :ok, %{subscriptionId: sub_id}, 1000)

      # Now check should do its job and notify...
      assert_push("subscription:data", data)

      # using '=' here to pattern match and validate format
      assert %{
               subscriptionId: ^sub_id,
               result: %{
                 data: result_data
               }
             } = data

      assert %{"checkNotify" => %{"id" => to_string(check.id)}} === result_data
    end

    test "triggers contact_notify when notify occurs", %{socket: socket} do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }

      {:ok, check} =
        CheckWatcher.create_start(%{
          description: "test",
          probe: "red",
          args: "test",
          contact: contact
        })

      sub = "subscription { contactNotify( name: \"#{check.contact.name}\" ) { id }}"
      ref = push_doc(socket, sub)
      assert_reply(ref, :ok, %{subscriptionId: sub_id}, 1000)
      assert_push("subscription:data", data)

      # using '=' here to pattern match and validate format
      assert %{
               subscriptionId: ^sub_id,
               result: %{
                 data: result_data
               }
             } = data

      assert %{"contactNotify" => %{"id" => to_string(check.id)}} === result_data
    end
  end
end
