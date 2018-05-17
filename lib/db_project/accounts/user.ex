defmodule DbProject.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbProject.Accounts.User
  alias DbProject.Accounts.Role
  alias DbProject.Members.Member

  schema "accounts_user" do
    field :email, :string
    field :name, :string

    many_to_many :roles, Role, join_through: "accounts_permissions", on_replace: :delete
    has_one :member, Member
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
