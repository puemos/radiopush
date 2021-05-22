defmodule Radiopush.Repo.Migrations.CreateGroupsUsers do
  use Ecto.Migration

  def change do
    create table(:groups_users, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :group_id, references(:groups, on_delete: :delete_all, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:groups_users, [:user_id, :group_id])
  end
end
