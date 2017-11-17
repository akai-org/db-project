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
      name: event.name,
      description: event.description,
      slug: event.slug,
      date: event.date,
      location: event.location,
      author_id: event.author_id,
      registration_url: event.registration_url,
      facebook_url: event.facebook_url,
      thumbnail_id: event.thumbnail_id,
      thumbnail_url: event.thumbnail_url,
      photo_id: event.photo_id,
      photo_url: event.photo_url,
      old_id: event.old_id}
  end
end
