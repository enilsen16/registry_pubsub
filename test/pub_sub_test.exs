defmodule PubSubTest do
  use ExUnit.Case
  doctest PubSub

  test "subscribes and broadcasts" do
    PubSub.subscribe("hello")
    PubSub.broadcast("hello", :world)
    assert_received :world
  end

  test "subscribes and broadcasts with multiple" do
    PubSub.subscribe("hello")
    Task.start_link( fn ->
      PubSub.broadcast("hello", :world)
    end)

    assert_received :world
  end
end
