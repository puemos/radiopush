defmodule Radiopush.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :channel_id, references(:channels, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create index(:members, [:user_id])
    create index(:members, [:channel_id])
  end
end
