defmodule DbProject.Repo.Migrations.CreateAccountsPermissions do
  use Ecto.Migration

  def change do
    create table(:accounts_permissions) do
      add :user_id, references(:accounts_user)
      add :role_id, references(:accounts_roles)
    end
  end
end
