defmodule Radiopush.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      timestamps(type: :utc_datetime_usec)
    end
  end
end
