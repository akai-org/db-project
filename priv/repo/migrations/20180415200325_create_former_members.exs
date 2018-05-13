defmodule DbProject.Repo.Migrations.CreateFormerMembers do
  use Ecto.Migration

  def change do
    create table(:former_members) do
      add :name, :string
      add :surname, :string
      add :github, :string

      timestamps()
    end

  end
end
