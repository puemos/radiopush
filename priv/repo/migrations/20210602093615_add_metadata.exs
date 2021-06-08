defmodule Radiopush.Repo.Migrations.AddMetadata do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :explicit, :boolean, null: false, default: false
      add :tempo, :float, null: false, default: 0.0
      add :genres, {:array, :string}
    end
  end

  def down do
    alter table(:posts) do
      remove :explicit
      remove :tempo
      remove :genres
    end
  end
end
