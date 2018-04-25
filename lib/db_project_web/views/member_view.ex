defmodule DbProjectWeb.MemberView do
  use DbProjectWeb, :view
  alias DbProjectWeb.MemberView

  def render("index.json", %{members: members}) do
    %{data: render_many(members, MemberView, "member.json")}
  end

  def render("member.json", %{member: member}) do
    %{id: member.id,
      name: member.name,
      surname: member.surname,
      github: member.github}
  end
end
