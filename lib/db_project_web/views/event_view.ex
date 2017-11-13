defmodule DbProjectWeb.EventView do
  use DbProjectWeb, :view
  alias DbProjectWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      title: event.title,
      description: event.description,
      location: event.location,
      date: event.date}
  end
end
