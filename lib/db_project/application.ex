defmodule DbProject.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    limit = %Cachex.Limit{ limit: 50, reclaim: 0.1 }
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(DbProject.Repo, []),
      # Start the endpoint when the application starts
      supervisor(DbProjectWeb.Endpoint, []),
      # Start your own worker by calling: DbProject.Worker.start_link(arg1, arg2, arg3)
      # worker(DbProject.Worker, [arg1, arg2, arg3]),
      worker(Cachex, [:events_lists_cache, [limit: limit]], id: :cachex_events_lists),
      worker(Cachex, [:events_units_cache, [limit: limit]], id: :cachex_events_units),
      worker(Cachex, [:former_members_lists_cache, [limit: limit]], id: :cachex_former_members_lists),
      worker(Cachex, [:former_members_units_cache, [limit: limit]], id: :cachex_former_members_units)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DbProject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DbProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
