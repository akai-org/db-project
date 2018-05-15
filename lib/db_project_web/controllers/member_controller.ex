defmodule DbProjectWeb.MemberController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member

  def index(conn, _params) do
    members = Members.list_members()
    render(conn, "index.json", members: members)
  end

  def show(conn, %{"id" => id}) do
    member = Members.get_member!(id)
    render(conn, "member.json", member: member)
  end

end
