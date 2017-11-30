defmodule DbProject.Repo.Migrations.CreateAccountsUser do
  use Ecto.Migration

  def change do
    create table(:accounts_user) do
      add :name, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:accounts_user, [:email])
  end
end
