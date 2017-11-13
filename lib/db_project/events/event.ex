defmodule DbProject.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Events.Event


  schema "events" do
    field :date, :utc_datetime
    field :description, :string
    field :location, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :description, :location, :date])
    |> validate_required([:title, :description, :location, :date])
  end
end
