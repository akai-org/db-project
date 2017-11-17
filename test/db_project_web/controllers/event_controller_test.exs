defmodule DbProjectWeb.EventControllerTest do
  use DbProjectWeb.ConnCase

  alias DbProject.Events
  alias DbProject.Events.Event

  @create_attrs %{author_id: 42, date: ~N[2010-04-17 14:00:00.000000], description: "some description", facebook_url: "some facebook_url", location: "some location", name: "some name", old_id: 42, photo_id: 42, photo_url: "some photo_url", registration_url: "some registration_url", slug: "some slug", thumbnail_id: 42, thumbnail_url: "some thumbnail_url"}
  @update_attrs %{author_id: 43, date: ~N[2011-05-18 15:01:01.000000], description: "some updated description", facebook_url: "some updated facebook_url", location: "some updated location", name: "some updated name", old_id: 43, photo_id: 43, photo_url: "some updated photo_url", registration_url: "some updated registration_url", slug: "some updated slug", thumbnail_id: 43, thumbnail_url: "some updated thumbnail_url"}
  @invalid_attrs %{author_id: nil, date: nil, description: nil, facebook_url: nil, location: nil, name: nil, old_id: nil, photo_id: nil, photo_url: nil, registration_url: nil, slug: nil, thumbnail_id: nil, thumbnail_url: nil}

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "author_id" => 42,
        "date" => ~N[2010-04-17 14:00:00.000000],
        "description" => "some description",
        "facebook_url" => "some facebook_url",
        "location" => "some location",
        "name" => "some name",
        "old_id" => 42,
        "photo_id" => 42,
        "photo_url" => "some photo_url",
        "registration_url" => "some registration_url",
        "slug" => "some slug",
        "thumbnail_id" => 42,
        "thumbnail_url" => "some thumbnail_url"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "author_id" => 43,
        "date" => ~N[2011-05-18 15:01:01.000000],
        "description" => "some updated description",
        "facebook_url" => "some updated facebook_url",
        "location" => "some updated location",
        "name" => "some updated name",
        "old_id" => 43,
        "photo_id" => 43,
        "photo_url" => "some updated photo_url",
        "registration_url" => "some updated registration_url",
        "slug" => "some updated slug",
        "thumbnail_id" => 43,
        "thumbnail_url" => "some updated thumbnail_url"}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
