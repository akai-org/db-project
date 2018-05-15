defmodule DbProjectWeb.UserController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member


  def show(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    render(conn, "show.html", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    changeset = Members.change_member(member)
    render(conn, "edit.html", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Members.get_member!(id)

    case Members.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: member_path(conn, :show, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", member: member, changeset: changeset)
    end
  end
end
