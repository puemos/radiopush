defmodule Radiopush.Repo.Migrations.ChannelDescription do
  use Ecto.Migration

  def change do
    alter table(:channels) do
      add :description, :text
    end
  end
end
