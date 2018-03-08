defmodule DbProjectWeb.Admin.UserController do
  use DbProjectWeb, :controller

  import Ecto.Query, warn: false
  alias DbProject.Accounts
  alias DbProject.Accounts.User
  alias DbProject.Accounts.Role
  alias DbProject.Repo

  plug DbProjectWeb.RequireLogin
  plug DbProjectWeb.RequireRole, role: :role_admin

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.User.changeset(user, %{})
    roles = Accounts.list_roles_for_select()
    render(conn, "edit.html", user: user, roles: roles, 
      changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user_role(user, user_params) do
      {:ok, %User{}} ->
        conn
        |> put_flash(:info, "Changed roles for #{user.name}")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        roles = Accounts.list_roles_for_select()
        
        conn
        |> put_flash(:error, "Something went wrong...")
        |> render("edit.html", user: user, roles: roles,
          changeset: changeset)
    end

  end
end