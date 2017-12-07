defmodule DbProject.EventsTest do
  use DbProject.DataCase, async: false

  alias DbProject.Events

  describe "events" do
    alias DbProject.Events.Event

    @valid_attrs %{author_id: 42, date: ~N[2010-04-17 14:00:00.000000], description: "some description", facebook_url: "some facebook_url", location: "some location", name: "some name", old_id: 42, photo_id: 42, photo_url: "some photo_url", registration_url: "some registration_url", slug: "some slug", thumbnail_id: 42, thumbnail_url: "some thumbnail_url"}
    @update_attrs %{author_id: 43, date: ~N[2011-05-18 15:01:01.000000], description: "some updated description", facebook_url: "some updated facebook_url", location: "some updated location", name: "some updated name", old_id: 43, photo_id: 43, photo_url: "some updated photo_url", registration_url: "some updated registration_url", slug: "some updated slug", thumbnail_id: 43, thumbnail_url: "some updated thumbnail_url"}
    @invalid_attrs %{author_id: nil, date: nil, description: nil, facebook_url: nil, location: nil, name: nil, old_id: nil, photo_id: nil, photo_url: nil, registration_url: nil, slug: nil, thumbnail_id: nil, thumbnail_url: nil}

    setup do
      Cachex.clear(:events_units_cache)
      Cachex.clear(:events_lists_cache)
      {:ok, %{}}
    end

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id and caches it" do
      assert {:ok, true} == Cachex.empty?(:events_units_cache)

      event = event_fixture()
      assert Events.get_event!(event.id) == event

      assert {:ok, false} == Cachex.empty?(:events_units_cache)
    end

    test "create_event/1 with valid data creates a event and clear lists cache" do
      Events.list_events()
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)

      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.author_id == 42
      assert event.date == ~N[2010-04-17 14:00:00.000000]
      assert event.description == "some description"
      assert event.facebook_url == "some facebook_url"
      assert event.location == "some location"
      assert event.name == "some name"
      assert event.old_id == 42
      assert event.photo_id == 42
      assert event.photo_url == "some photo_url"
      assert event.registration_url == "some registration_url"
      assert event.slug == "some slug"
      assert event.thumbnail_id == 42
      assert event.thumbnail_url == "some thumbnail_url"

      assert {:ok, true} == Cachex.empty?(:events_lists_cache)
    end

    test "create_event/1 with invalid data returns error changeset and doesn't clear cache" do
      Events.list_events()
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)

      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)
    end

    test "update_event/2 with valid data updates the event and clears cache" do
      event = event_fixture()
      Events.list_events()
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)
      Events.get_event!(Integer.to_string(event.id))
      assert {:ok, false} == Cachex.empty?(:events_units_cache)

      assert {:ok, event} = Events.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.author_id == 43
      assert event.date == ~N[2011-05-18 15:01:01.000000]
      assert event.description == "some updated description"
      assert event.facebook_url == "some updated facebook_url"
      assert event.location == "some updated location"
      assert event.name == "some updated name"
      assert event.old_id == 43
      assert event.photo_id == 43
      assert event.photo_url == "some updated photo_url"
      assert event.registration_url == "some updated registration_url"
      assert event.slug == "some updated slug"
      assert event.thumbnail_id == 43
      assert event.thumbnail_url == "some updated thumbnail_url"

      assert {:ok, true} == Cachex.empty?(:events_lists_cache)
      assert {:ok, false} == Cachex.exists?(:events_units_cache, Integer.to_string(event.id))
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      Events.list_events()
      Events.get_event!(Integer.to_string(event.id))
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)
      assert {:ok, true} == Cachex.exists?(:events_units_cache, Integer.to_string(event.id))

      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert {:ok, true} == Cachex.exists?(:events_units_cache, Integer.to_string(event.id))
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)

      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      Events.list_events()
      Events.get_event!(Integer.to_string(event.id))
      assert {:ok, false} == Cachex.empty?(:events_lists_cache)
      assert {:ok, true} == Cachex.exists?(:events_units_cache, Integer.to_string(event.id))

      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end

      assert {:ok, false} == Cachex.exists?(:events_units_cache, Integer.to_string(event.id))
      assert {:ok, true} == Cachex.empty?(:events_lists_cache)
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
