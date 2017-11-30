defmodule DbProjectWeb.View.Helpers do
  def is_logged?(conn) do
    if conn.assigns.current_user, do: true, else: false
  end
end
