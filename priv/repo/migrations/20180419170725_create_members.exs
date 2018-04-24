defmodule DbProject.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string
      add :surname, :string
      add :github, :string

      timestamps()
    end

  end
end
