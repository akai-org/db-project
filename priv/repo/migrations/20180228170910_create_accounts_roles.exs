defmodule DbProject.Repo.Migrations.CreateAccountsRole do
  use Ecto.Migration

  def change do
    create table(:accounts_roles) do
      add :name, :string
      add :atom, :string

      timestamps()
    end

    create index(:accounts_roles, [:atom])
  end
end
