defmodule CheckPointWeb.Schema.ContactSubscription do
  use Absinthe.Schema.Notation

  @desc "Subscribe to alerts for a single check"
  object :contact_subscriptions do
    @doc "Alert was escalated"
    field :contact_alert, :check do
      arg :id, non_null(:id)
      config fn args, _info ->
        {:ok, topic: args.id}
      end
    end
  end
  
end
