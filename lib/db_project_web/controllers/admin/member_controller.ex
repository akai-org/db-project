defmodule DbProjectWeb.Admin.MemberController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member

  def index(conn, _params) do
    members = Members.list_members()
    render(conn, "index.html", members: members)
  end

  def delete(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    {:ok, _member} = Members.delete_member(member)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: member_path(conn, :index))
  end
end
