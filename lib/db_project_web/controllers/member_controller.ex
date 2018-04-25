defmodule DbProjectWeb.MemberController do
  use DbProjectWeb, :controller

  alias DbProject.Members
  alias DbProject.Members.Member

  action_fallback DbProjectWeb.FallbackController

  def index(conn, params) do
    if params == %{}, do: params = %{"all" => "true"}

    case params do
      %{"all" => "true"} ->
        members = Members.list_members(%{"all" => "true"})

        conn
        |> render("index.json", members: members)

      _ ->
        members = Members.list_members(params)

        conn
        |> Scrivener.Headers.paginate(members)
        |> render("index.json", members: members)
    end
  end

end
