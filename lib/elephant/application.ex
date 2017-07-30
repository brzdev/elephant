defmodule Elephant.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    import Supervisor.Spec, warn: false

    children = [
        supervisor(Elephant.Repo, []),
        Plug.Adapters.Cowboy.child_spec(:http, Elephant.Router, [], port: 4000)
      # Starts a worker by calling: Elephant.Worker.start_link(arg)
      # {Elephant.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elephant.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
