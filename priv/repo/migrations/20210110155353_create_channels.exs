defmodule Radiopush.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :private, :boolean

      timestamps(type: :utc_datetime_usec)
    end

    create index(:channels, [:inserted_at])
  end
end
