defmodule DbProject.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :string
      add :location, :string
      add :date, :utc_datetime

      timestamps()
    end

  end
end
