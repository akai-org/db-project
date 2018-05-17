defmodule DbProjectWeb.UserController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member
  alias DbProject.Accounts.User

  plug DbProjectWeb.RequireLogin


  def show(conn, _params) do
    member = Members.get_member_by_user(conn.assigns.current_user)
    render(conn, "show.html", member: member)
  end

  def edit(conn, _params) do
    member = Members.get_member_by_user(conn.assigns.current_user)
    changeset = Members.change_member(member)
    render(conn, "edit.html", member: member, changeset: changeset)
  end

  def update(conn, %{"member" => member_params}) do
    member = Members.get_member_by_user(conn.assigns.current_user)

    case Members.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: user_path(conn, :show))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", member: member, changeset: changeset)
    end
  end
end
