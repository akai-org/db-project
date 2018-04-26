defmodule DbProjectWeb.FormerMemberView do
  use DbProjectWeb, :view
  alias DbProjectWeb.FormerMemberView

  def render("index.json", %{former_members: former_members}) do
    %{data: render_many(former_members, FormerMemberView, "former_member.json")}
  end

  def render("former_member.json", %{former_member: former_member}) do
    %{id: former_member.id,
      name: former_member.name,
      surname: former_member.surname,
      github: former_member.github}
  end
end
