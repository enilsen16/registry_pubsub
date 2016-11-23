defmodule PubSub do
  @moduledoc """
  Documentation for PubSub.
  """

  def subscribe(topic) do
    Registry.register(PubSub.Registry, topic, nil)
  end

  def broadcast(topic, msg) do
    Registry.dispatch(PubSub.Registry, topic, fn pids_with_values ->
      for {pid, _} <- pids_with_values do
        send(pid, msg)
      end
    end)
    :ok
  end
end
