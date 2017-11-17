defmodule DbProject.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :text
      add :slug, :string
      add :date, :naive_datetime
      add :location, :string
      add :author_id, :integer
      add :registration_url, :string
      add :facebook_url, :string
      add :thumbnail_id, :integer
      add :thumbnail_url, :string
      add :photo_id, :integer
      add :photo_url, :string
      add :old_id, :integer

      timestamps()
    end

  end
end
