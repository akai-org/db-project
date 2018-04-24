defmodule DbProjectWeb.Admin.MemberController do
  use DbProjectWeb, :controller

  alias DbProject.Members #czemu tak aliasujemy, a nie DbProject.Members.Members
  alias DbProject.Members.Member

  plug DbProjectWeb.RequireLogin
  plug DbProjectWeb.RequireRole, role: :member_admin

  def index(conn, params) do
    members = Members.list_members(params)
    render conn, "index.html", members: members
  end

  def new(conn, _params) do
    changeset = Member.changeset(%Member{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Members.create_member(member_params) do
      {:ok, %Member{} = member} ->
        conn
        |> put_flash(:info, "Member created")
        |> redirect(to: admin_member_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    changeset = Members.Member.changeset(member, %{})
    render(conn, "edit.html", changeset: changeset, member: member)
  end

  def update(conn,  %{"id" => id, "member" => member_params}) do
    member = Members.get_member!(id)
    case Members.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Updated")
        |> redirect(to: admin_member_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("edit.html", member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    case Members.delete_member(member) do
      {:ok, %Member{} = member} ->
        conn
        |> put_flash(:info, "Deleted event: #{member.name}")
        |> redirect(to: admin_member_path(conn, :index))
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Oops! Couldn't delete the event.")
        |> redirect(to: admin_member_path(conn, :index))
    end
  end

end
