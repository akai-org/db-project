# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :db_project,
  ecto_repos: [DbProject.Repo]

# Configures the endpoint
config :db_project, DbProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oqzvFx8KTxXuwvF0gD81nwVhdaWQ0EQ4CrR5f1eoOqN5sGcldf8pQp8eIo9YrAsB",
  render_errors: [view: DbProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DbProject.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile", hd: "akai.org.pl"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :scrivener_html,
  routes_helper: DbProjectWeb.Router.Helpers,
  # If you use a single view style everywhere, you can configure it here. See View Styles below for more info.
  view_style: :bootstrap
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
