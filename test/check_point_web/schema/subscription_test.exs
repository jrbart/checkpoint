defmodule CheckPointWeb.Schema.SubscriptionTest do
  use CheckPointWeb.SubscriptionCase
  use CheckPoint.RepoCase

  alias CheckPoint.Checks

  describe "subscription" do
    test "triggers check_alert when alert occurs", %{socket: socket} do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }

      {:ok, check} =
        Checks.create_check(%{
          description: "test",
          action: "red",
          args: "test",
          contact: contact
        })

      sub = "subscription { checkAlert( id: \"#{check.id}\" ) { id }}"
      ref = push_doc(socket, sub)

      # Because timing is fast, might have to skip this assert
      assert_reply(ref, :ok, %{subscriptionId: sub_id}, 1000)

      # Now check should do its job and publish an alert...
      assert_push("subscription:data", data)

      # using '=' here to pattern match and validate format
      assert %{
               subscriptionId: ^sub_id,
               result: %{
                 data: result_data
               }
             } = data

      assert %{"checkAlert" => %{"id" => to_string(check.id)}} === result_data
    end

    test "triggers contact_alert when alert occurs", %{socket: socket} do
      contact = %{
        name: "new_name",
        description: "Randy Bartels",
        type: "email",
        detail: "jrb@codingp.com"
      }

      {:ok, check} =
        Checks.create_check(%{
          description: "test",
          action: "red",
          args: "test",
          contact: contact
        })

      sub = "subscription { contactAlert( id: \"#{check.contact.id}\" ) { id }}"
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

      assert %{"contactAlert" => %{"id" => to_string(check.id)}} === result_data
    end
  end
end
