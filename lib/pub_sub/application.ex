defmodule PubSub.Remote do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_info({:broadcast, topic, message}, state) do
    PubSub.local_broadcast(topic, message)
    {:noreply, state}
  end
end

defmodule PubSub.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    registry_opts = [partitions: System.schedulers_online]

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Registry, [:duplicate, PubSub.Registry, registry_opts]),
      worker(PubSub.Remote, [])
      # Starts a worker by calling: PubSub.Worker.start_link(arg1, arg2, arg3)
      # worker(PubSub.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
