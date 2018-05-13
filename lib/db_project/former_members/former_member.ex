defmodule DbProject.FormerMembers.FormerMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.FormerMembers.FormerMember

  @timestamps_opts [type: Ecto.DateTime, usec: false]
  schema "former_members" do
    field :github, :string
    field :name, :string
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(%FormerMember{} = former_member, attrs) do
    former_member
    |> cast(attrs, [:name, :surname, :github])
    |> validate_required([:name, :surname])
  end
end
