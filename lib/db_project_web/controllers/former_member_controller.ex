defmodule DbProjectWeb.FormerMemberController do
  use DbProjectWeb, :controller

  alias DbProject.FormerMembers
  alias DbProject.FormerMembers.FormerMember

  action_fallback DbProjectWeb.FallbackController

  def index(conn, params) do
    if params == %{}, do: params = %{"all" => "true"}

    case params do
      %{"all" => "true"} ->
        former_members = FormerMembers.list_former_members(%{"all" => "true"})

        conn
        |> render("index.json", former_members: former_members)

      _ ->
        former_members = FormerMembers.list_former_members(params)

        conn
        |> Scrivener.Headers.paginate(former_members)
        |> render("index.json", former_members: former_members)
    end
  end

end
