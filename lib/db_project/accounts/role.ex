defmodule DbProject.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Accounts.Role
  alias DbProject.Accounts.User

  schema "accounts_roles" do
    field :name, :string
    field :atom, :string

    many_to_many :users, User, join_through: "accounts_permissions"
    timestamps()
  end

  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name, :atom])
    |> validate_required([:name, :atom])
  end
end