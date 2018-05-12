defmodule DbProjectWeb.Admin.FormerMemberController do
  use DbProjectWeb, :controller

  alias DbProject.FormerMembers
  alias DbProject.FormerMembers.FormerMember

  plug DbProjectWeb.RequireLogin
  plug DbProjectWeb.RequireRole, role: :former_member_admin

  def index(conn, params) do
    former_members = FormerMembers.list_former_members(params)
    render conn, "index.html", former_members: former_members
  end

  def new(conn, _params) do
    changeset = FormerMember.changeset(%FormerMember{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"former_member" => former_member_params}) do
    case FormerMembers.create_former_member(former_member_params) do
      {:ok, %FormerMember{} = former_member} ->
        conn
        |> put_flash(:info, "Member created")
        |> redirect(to: admin_former_member_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    former_member = FormerMembers.get_former_member!(id)
    changeset = FormerMembers.FormerMember.changeset(former_member, %{})
    render(conn, "edit.html", changeset: changeset, former_member: former_member)
  end

  def update(conn,  %{"id" => id, "former_member" => former_member_params}) do
    former_member = FormerMembers.get_former_member!(id)
    case FormerMembers.update_former_member(former_member, former_member_params) do
      {:ok, former_member} ->
        conn
        |> put_flash(:info, "Updated")
        |> redirect(to: admin_former_member_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("edit.html", former_member: former_member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    former_member = FormerMembers.get_former_member!(id)
    case FormerMembers.delete_former_member(former_member) do
      {:ok, %FormerMember{} = former_member} ->
        conn
        |> put_flash(:info, "Deleted event: #{former_member.name}")
        |> redirect(to: admin_former_member_path(conn, :index))
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Oops! Couldn't delete the event.")
        |> redirect(to: admin_former_member_path(conn, :index))
    end
  end

end
