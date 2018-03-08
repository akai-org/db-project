defmodule DbProjectWeb.AuthController do
  use DbProjectWeb, :controller
  plug Ueberauth
  alias DbProject.Accounts

  def login(conn, _params) do
    redirect(conn, to: auth_path(conn, :request, "google"))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, %Accounts.User{} = user} <- Accounts.auth_user(auth) do
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Zalogowano")
        |> redirect(to: page_path(conn, :index))
    else
        {:error, :wrong_domain} -> conn |> put_flash(:error, "Zła domena") |> redirect(to: page_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} -> conn |> put_flash(:error, "Błąd bazy danych") |> redirect(to: page_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Wylogowano")
    |> redirect(to: page_path(conn, :index))
  end
end
