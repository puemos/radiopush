defmodule Radiopush.Repo.Migrations.CreatePostReactions do
  use Ecto.Migration

  def change do
    create table(:post_reactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)
      add :emoji, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:post_reactions, [:emoji, :user_id, :post_id])
    create index(:post_reactions, [:user_id])
    create index(:post_reactions, [:post_id])
  end
end
