defmodule DbProjectWeb.Admin.RoleController do
  use DbProjectWeb, :controller

  alias DbProject.Accounts
  alias DbProject.Accounts.Role

  plug DbProjectWeb.RequireLogin

  def index(conn, _params) do
    roles = Accounts.list_roles()
    render(conn, "index.html", roles: roles)
  end

  def new(conn, _params) do
    changeset = Role.changeset(%Role{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"role" => role_params}) do
    case Accounts.create_role(role_params) do
      {:ok, %Role{} = role} ->
        conn
        |> put_flash(:info, "Created role")
        |> redirect(to: admin_role_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end
end