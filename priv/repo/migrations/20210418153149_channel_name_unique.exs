defmodule Radiopush.Repo.Migrations.ChannelNameUnique do
  use Ecto.Migration

  def change do
    create unique_index(:channels, [:name])
  end
end
