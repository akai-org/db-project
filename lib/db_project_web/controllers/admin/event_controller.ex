defmodule DbProjectWeb.Admin.EventController do
  use DbProjectWeb, :controller

  alias DbProject.Events
  alias DbProject.Events.Event

  plug DbProjectWeb.RequireLogin
  plug DbProjectWeb.RequireRole, role: :event_admin

  def index(conn, params) do
    events = Events.list_events(params)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Events.create_event(event_params) do
      {:ok, %Event{} = event} ->
        conn 
        |> put_flash(:info, "Created event")
        |> redirect(to: admin_event_path(conn, :show, event.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.Event.changeset(event, %{})
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)
    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Updated")
        |> render("show.html", event: event)
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    case Events.delete_event(event) do
      {:ok, %Event{} = event} -> 
        conn
        |> put_flash(:info, "Deleted event: #{event.name}")
        |> redirect(to: admin_event_path(conn, :index))
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Oops! Couldn't delete the event.")
        |> redirect(to: admin_event_path(conn, :index))
    end
  end
end
