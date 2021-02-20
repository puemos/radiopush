defmodule Radiopush.Repo.Migrations.UserPrivacyAndTAC do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :accept_tac, :boolean, null: false
    end
  end
end
