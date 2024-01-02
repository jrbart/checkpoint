defmodule CheckPointWeb.SubscriptionCase do
  @moduledoc """
    Test case for GraphQL subscriptions
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use CheckPointWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: CheckPointWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(CheckPointWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
