defmodule CheckPointWeb.Schema.CheckSubscription do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "Subscribe to notifications for a single check"
  object :check_subscriptions do
    @desc "Notify when down"
    field :check_notify, :check do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end
    end
  end
end
