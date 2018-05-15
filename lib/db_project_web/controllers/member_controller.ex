defmodule DbProjectWeb.MemberController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member

  def index(conn, _params) do
    members = Members.list_members()
    json conn, members
  end

  def new(conn, _params) do
    changeset = Members.change_member(%Member{})
    render(conn, "new.json", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Members.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member created successfully.")
        |> redirect(to: member_path(conn, :show, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    render(conn, "show.json", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    changeset = Members.change_member(member)
    render(conn, "edit.json", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Members.get_member!(id)

    case Members.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: member_path(conn, :show, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.json", member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    {:ok, _member} = Members.delete_member(member)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: member_path(conn, :index))
  end
end
