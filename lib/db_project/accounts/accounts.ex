defmodule DbProject.Accounts do
  import Ecto.Query, warn: false
  alias DbProject.Accounts.User
  alias DbProject.Accounts.Role
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

  def list_users() do
    Repo.all(User)
  end

  def list_roles() do
    Repo.all(Role)
  end

  def list_roles_for_select() do
    Repo.all(from r in Role, select: {r.name, r.id})
  end

  def create_role(attrs \\ %{}) do
    response = %Role{}
      |> Role.changeset(attrs)
      |> Repo.insert()
  end

  def get_user!(id) do
    query = from u in User, 
      where: u.id == ^id,
      preload: [:roles]
    Repo.one(query)
  end

  def update_user_role(%User{} = user, %{"roles" => new_roles_ids} = params) do
    new_roles_ids = Enum.map(new_roles_ids, &(String.to_integer(&1)))

    roles = load_roles(new_roles_ids)

    user
    |> Ecto.Changeset.change() 
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Repo.update()
  end

  defp load_roles(roles_ids) do
    case roles_ids do
      [] -> []
      ids -> Repo.all(from r in Role, where: r.id in ^ids)
    end
  end
end
