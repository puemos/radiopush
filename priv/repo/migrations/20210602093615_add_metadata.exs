defmodule Radiopush.Repo.Migrations.AddMetadata do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :explicit, :boolean, null: false, default: false
      add :duration_ms, :integer, null: false, default: 0
    end
  end
end
