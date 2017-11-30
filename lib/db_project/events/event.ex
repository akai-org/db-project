defmodule DbProject.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Events.Event


  schema "events" do
    field :author_id, :integer
    field :date, :naive_datetime
    field :description, :string
    field :facebook_url, :string
    field :location, :string
    field :name, :string
    field :old_id, :integer
    field :photo_id, :integer
    field :photo_url, :string
    field :registration_url, :string
    field :slug, :string
    field :thumbnail_id, :integer
    field :thumbnail_url, :string

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :description, :slug, :date, :location, :author_id, :registration_url, :facebook_url, :thumbnail_id, :thumbnail_url, :photo_id, :photo_url, :old_id])
    |> validate_required([:name, :description, :slug])
  end
end
