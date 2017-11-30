defmodule DbProjectWeb.Router do
  use DbProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DbProjectWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/admin", PageController, :admin
  end

  # Other scopes may use custom stacks.
  scope "/api", DbProjectWeb do
    pipe_through :api

    resources "/events", EventController, only: [:index, :show]
  end

  scope "/auth", DbProjectWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
