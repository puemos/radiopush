defmodule Radiopush.Repo.Migrations.ChannelPrivate do
  use Ecto.Migration

  def change do
    alter table(:channels) do
      add :private, :boolean
    end
  end
end
