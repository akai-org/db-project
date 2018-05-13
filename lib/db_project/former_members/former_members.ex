defmodule DbProject.FormerMembers do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false
  alias DbProject.Repo

  alias DbProject.FormerMembers.FormerMember

  @doc """
  Returns the list of former_members.

  ## Examples

      iex> list_former_members()
      [%Member{}, ...]

  """
  def list_former_members(params \\ %{"all" => "true"})
  def list_former_members(%{"all" => "true"} = params) do
    {_status, former_members} = Cachex.get(:former_members_lists_cache, params, fallback: fn(_key) ->
        Repo.all(FormerMember)
    end)
    former_members
    #[%FormerMember{id: 1, name: 'sds',surname: 'fsdfsd', github: 'afsfs'}] #test
  end

  def list_former_members(params) do
    {_status, former_members} = Cachex.get(:former_members_lists_cache, params, fallback: fn(params) ->
        Repo.paginate(FormerMember, params)
      end)
    former_members
    #[%FormerMember{id: 1, name: 'sds',surname: 'fsdfsd', github: 'afsfs'}] #test
  end

  @doc """
  Gets a single former_member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_former_member!(123)
      %Member{}

      iex> get_former_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_former_member!(id) do
    {_status, former_member} = Cachex.get(:former_members_units_cache, id, fallback: fn(id) ->
        Repo.get!(FormerMember, id)
    end)
    former_member
  end

  @doc """
  Creates a former_member.

  ## Examples

      iex> create_former_member(%{field: value})
      {:ok, %Member{}}

      iex> create_former_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_former_member(attrs \\ %{}) do
    response = %FormerMember{}
    |> FormerMember.changeset(attrs)
    |> Repo.insert()

    case response do
      {:ok, _} ->
        # Clear cache only when new event is added
        Cachex.clear(:former_members_lists_cache)
        response
      _ ->
        response
    end
  end

  @doc """
  Updates a former_member.

  ## Examples

      iex> update_former_member(former_member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_former_member(former_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_former_member(%FormerMember{} = former_member, attrs) do
    response = former_member
    |> FormerMember.changeset(attrs)
    |> Repo.update()

    case response do
      {:ok, _} ->
        Cachex.del(:former_members_units_cache, Integer.to_string(former_member.id))
        Cachex.clear(:former_members_lists_cache)
        response
      _ ->
        response
    end
  end

  @doc """
  Deletes a Member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_former_member(%FormerMember{} = former_member) do
    Cachex.del(:former_members_units_cache, Integer.to_string(former_member.id))
    Cachex.clear(:former_members_lists_cache)
    Repo.delete(former_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_former_member(%FormerMember{} = former_member) do
    FormerMember.changeset(former_member, %{})
  end
end
