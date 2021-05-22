defmodule Radiopush.Repo.Migrations.CreateUsersPermissions do
  use Ecto.Migration

  def change do
    create table(:users_permissions, primary_key: false) do
      add :permission_id, references(:permissions, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:users_permissions, [:permission_id, :user_id])
  end
end
