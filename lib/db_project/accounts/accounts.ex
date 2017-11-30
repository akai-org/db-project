defmodule DbProject.Accounts do
  import Ecto.Query, warn: false
  alias DbProject.Accounts.User
  alias DbProject.Repo

  def auth_user(%Ueberauth.Auth{} = auth) do
    with {:ok} <- check_domain(auth),
         {:ok, %User{} = user} <- login_user(auth) do
      {:ok, user}
    else
      {:error, :wrong_domain} -> {:error, :wrong_domain}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
    end
  end

  defp check_domain(%Ueberauth.Auth{extra: extra}) do
    case extra.raw_info.user["hd"] do
      "akai.org.pl" -> {:ok}
      _             -> {:error, :wrong_domain}
    end
  end

  defp login_user(%Ueberauth.Auth{info: user_info}) do
    email = user_info.email
    case get_user_by_email(email) do
      %User{} = user -> {:ok, user}
      nil -> create_user(user_info)
    end
  end

  defp get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  defp create_user(%{email: email, name: name}) do
    %User{}
    |> User.changeset(%{email: email, name: name})
    |> Repo.insert()
  end
end
