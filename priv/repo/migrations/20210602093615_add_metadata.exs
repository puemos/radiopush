defmodule Radiopush.Repo.Migrations.AddMetadata do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :explicit, :boolean, null: false, default: false
      add :tempo, :float, null: false, default: 0.0
      add :duration_ms, :float, null: false, default: 0.0
    end
  end

  def down do
    alter table(:posts) do
      remove :explicit
      remove :tempo
      remove :duration_ms
    end
  end
end
