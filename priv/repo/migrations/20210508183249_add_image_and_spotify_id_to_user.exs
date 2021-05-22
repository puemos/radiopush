defmodule Radiopush.Repo.Migrations.AddImageAndSpotifyIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image, :text
      add :spotify_id, :text
    end
  end
end
