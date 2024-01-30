defmodule CheckPointWeb.Schema.ContactSubscription do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "Subscribe to all notification for a contact"
  object :contact_subscriptions do
    @desc "notify when down"
    field :contact_notify, :check do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end
    end
  end
end
