defmodule DbProject.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Members.Member

  @timestamps_opts [type: Ecto.DateTime, usec: false]
  schema "members" do
    field :github, :string
    field :name, :string
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(%Member{} = member, attrs) do
    member
    |> cast(attrs, [:name, :surname, :github])
    |> validate_required([:name, :surname])
  end
end
