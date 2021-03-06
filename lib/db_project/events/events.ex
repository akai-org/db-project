defmodule DbProject.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias DbProject.Repo

  alias DbProject.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(params \\ %{"all" => "true"})
  def list_events(%{"all" => "true"} = params) do
    {_status, events} = Cachex.get(:events_lists_cache, params, fallback: fn(_key) ->
        Repo.all(Event)
    end)
    events
  end

  def list_events(params) do
    {_status, events} = Cachex.get(:events_lists_cache, params, fallback: fn(params) ->
        Repo.paginate(Event, params)
    end)
    events
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    {_status, event} = Cachex.get(:events_units_cache, id, fallback: fn(id) ->
        Repo.get!(Event, id)
    end)
    event
  end
  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    response = %Event{}
      |> Event.changeset(attrs)
      |> Repo.insert()

    case response do
      {:ok, _} ->
        # Clear cache only when new event is added
        Cachex.clear(:events_lists_cache)
        response
      _ ->
        response
    end
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    response = event
      |> Event.changeset(attrs)
      |> Repo.update()

    case response do
      {:ok, _} ->
        Cachex.del(:events_units_cache, Integer.to_string(event.id))
        Cachex.clear(:events_lists_cache)
        response
      _ ->
        response
    end
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Cachex.del(:events_units_cache, Integer.to_string(event.id))
    Cachex.clear(:events_lists_cache)

    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
