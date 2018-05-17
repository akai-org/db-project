defmodule DbProjectWeb.Router do
  use DbProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DbProjectWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DbProjectWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/user", DbProjectWeb do
    pipe_through :browser
    get "/show", UserController, :show
    get "/edit", UserController, :edit
    patch "/update", UserController, :update
    put "/update", UserController, :update
    delete "/delete", UserController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api", DbProjectWeb do
    pipe_through :api

    resources "/events", EventController, only: [:index, :show]
    resources "/former_members", FormerMemberController, only: [:index, :show]
    resources "/members", MemberController, only: [:index, :show]
  end

  scope "/auth", DbProjectWeb do
    pipe_through :browser

    post "/", AuthController, :login
    delete "/logout", AuthController, :logout

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/admin", DbProjectWeb, as: :admin do
    pipe_through :browser

    resources "/events", Admin.EventController
    resources "/roles", Admin.RoleController, only: [:index, :create, :new, :delete]
    resources "/user", Admin.UserController, only: [:index, :edit, :update]
    resources "/former_member", Admin.FormerMemberController, only: [:index, :create, :new, :edit, :update, :delete]
    resources "/member", Admin.MemberController, only: [:index, :delete]
  end

end
