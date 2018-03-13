defmodule DbProjectWeb.View.Helpers do
  alias DbProject.Accounts

  def is_logged?(conn) do
    if conn.assigns.current_user, do: true, else: false
  end

  def has_role?(conn, role) do
    if is_nil(conn.assigns.current_user), do: false, else: 
      Accounts.has_role(conn.assigns.current_user, role)
  end
end
