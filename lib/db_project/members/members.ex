defmodule DbProject.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false
  alias DbProject.Repo

  alias DbProject.Members.Member

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members(params \\ %{"all" => "true"})
  def list_members(%{"all" => "true"} = params) do
    {_status, members} = Cachex.get(:members_lists_cache, params, fallback: fn(_key) ->
        Repo.all(Member)
    end)
    members
  end

  def list_members(params) do
    {_status, members} = Cachex.get(:members_lists_cache, params, fallback: fn(params) ->
        Repo.paginate(Member, params)
      end)
    members
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id) do
    {_status, member} = Cachex.get(:members_units_cache, id, fallback: fn(id) ->
        Repo.get!(Member, id)
    end)
    member
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    response = %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()

    case response do
      {:ok, _} ->
        # Clear cache only when new event is added
        Cachex.clear(:members_lists_cache)
        response
      _ ->
        response
    end
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    response = member
    |> Member.changeset(attrs)
    |> Repo.update()

    case response do
      {:ok, _} ->
        Cachex.del(:members_units_cache, Integer.to_string(member.id))
        Cachex.clear(:members_lists_cache)
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
  def delete_member(%Member{} = member) do
    Cachex.del(:members_units_cache, Integer.to_string(member.id))
    Cachex.clear(:members_lists_cache)
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end
end
