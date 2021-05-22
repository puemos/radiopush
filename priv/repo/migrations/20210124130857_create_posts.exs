defmodule Radiopush.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :channel_id, references(:channels, on_delete: :nothing, type: :binary_id)
      add :type, :string
      add :song, :string
      add :album, :string
      add :musician, :string
      add :url, :string
      add :image, :string
      add :audio_preview, :string

      timestamps(type: :utc_datetime_usec)
    end

    create index(:posts, [:user_id])
    create index(:posts, [:channel_id])
  end
end
