defmodule Radiopush.Repo.Migrations.CreateChannelsUsers do
  use Ecto.Migration

  def change do
    create table(:channels_users, primary_key: false) do
      add :channel_id, references(:channels, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end

    alter table(:channels) do
      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id)
    end

    create unique_index(:channels_users, [:channel_id, :user_id])
  end
end
