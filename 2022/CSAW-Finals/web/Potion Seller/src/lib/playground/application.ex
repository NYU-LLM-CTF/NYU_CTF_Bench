defmodule Playground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    # Set up libcluster to handle node discovery and connection logic for us automatically.
    topologies = [
      cluster: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Playground.ClusterSupervisor]]}
    ]

    app_config = Application.get_env(:playground, Playground)
    role = app_config[:role]

    # This is improper (we should separate the separate roles into separate applications)
    # but this works for this little codebase.

    children =
      if role in ["executor", "all"] do
        children ++
          [
            Playground.Executor
          ]
      else
        children
      end

    children =
      if role in ["web", "all"] do
        children ++
          [
            # Start the Telemetry supervisor
            PlaygroundWeb.Telemetry,
            # Start the PubSub system
            {Phoenix.PubSub, name: Playground.PubSub},
            # Start the Endpoint (http/https)
            PlaygroundWeb.Endpoint,
            # Start a worker by calling: Playground.Worker.start_link(arg)
            # {Playground.Worker, arg}
            {Task.Supervisor, name: Playground.TaskSupervisor}
          ]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Playground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
