defmodule DbProjectWeb.EventController do
  use DbProjectWeb, :controller

  alias DbProject.Events
  alias DbProject.Events.Event

  action_fallback DbProjectWeb.FallbackController

  def index(conn, params) do
    if params == %{}, do: params = %{"all" => "true"}

    case params do
      %{"all" => "true"} ->
        events = Events.list_events(%{"all" => "true"})

        conn
        |> render("index.json", events: events)

      _ ->
        events = Events.list_events(params)

        conn
        |> Scrivener.Headers.paginate(events)
        |> render("index.json", events: events)
    end
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
