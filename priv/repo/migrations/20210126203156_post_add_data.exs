defmodule Radiopush.Repo.Migrations.PostAddData do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :body
      add :type, :string
      add :song, :string
      add :album, :string
      add :musician, :string
      add :url, :string
      add :image, :string
    end

  end
end
