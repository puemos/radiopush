defmodule Radiopush.Repo.Migrations.CascadeChannelDelete do
  use Ecto.Migration

  def change do
    alter table(:posts, primary_key: false) do
      modify :user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        from: references(:users, on_delete: :nothing, type: :binary_id)

      modify :channel_id, references(:channels, on_delete: :delete_all, type: :binary_id),
        from: references(:channels, on_delete: :nothing, type: :binary_id)
    end

    alter table(:post_reactions, primary_key: false) do
      modify :user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        from: references(:users, on_delete: :nothing, type: :binary_id)

      modify :post_id, references(:posts, on_delete: :delete_all, type: :binary_id),
        from: references(:posts, on_delete: :nothing, type: :binary_id)
    end
  end
end
