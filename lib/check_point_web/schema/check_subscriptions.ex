defmodule CheckPointWeb.Schema.CheckSubscription do
  use Absinthe.Schema.Notation

  @desc "Subscribe to alerts for a single check"
  object :check_subscriptions do
    @doc "Alert was escalated"
    field :check_alert, :check do
      arg :id, non_null(:id)
      config fn args, _info ->
        {:ok, topic: args.id}
      end
    end
  end
  
end
