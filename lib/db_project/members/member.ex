defmodule DbProject.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Members.Member
  alias DbProject.Accounts.User


  schema "members" do
    field :github, :string
    field :name, :string
    field :surname, :string

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(%Member{} = member, attrs) do
    member
    |> cast(attrs, [:name, :surname, :github, :user_id])
    |> validate_required([:name, :surname, :github, :user_id])
  end
end
