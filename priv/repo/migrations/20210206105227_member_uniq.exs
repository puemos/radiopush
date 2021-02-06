defmodule Radiopush.Repo.Migrations.MemberUniq do
  use Ecto.Migration

  def change do
    create unique_index(:members, [:user_id, :channel_id, :role])
  end
end
