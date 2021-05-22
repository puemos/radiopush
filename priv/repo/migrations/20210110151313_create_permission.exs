defmodule Radiopush.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :object, :string, null: false
      add :action, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:permissions, [:object, :action])
  end
end
