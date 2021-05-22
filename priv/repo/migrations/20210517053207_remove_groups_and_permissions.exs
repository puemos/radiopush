defmodule Radiopush.Repo.Migrations.RemoveGroupsAndPermissions do
  use Ecto.Migration

  def change do
    drop_if_exists table("channels_groups")
    drop_if_exists table("groups_users")
    drop_if_exists table("groups")
    drop_if_exists table("users_permissions")
    drop_if_exists table("permissions")
  end
end
