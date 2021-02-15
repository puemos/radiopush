defmodule Radiopush.Repo.Migrations.UserNickname do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nickname, :string, null: false
    end
  end
end
