defmodule Radiopush.Repo.Migrations.CreateChannelsGroups do
  use Ecto.Migration

  def change do
    create table(:channels_groups, primary_key: false) do
      add :channel_id, references(:channels, on_delete: :delete_all, type: :binary_id)
      add :group_id, references(:groups, on_delete: :delete_all, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:channels_groups, [:channel_id, :group_id])
  end
end
