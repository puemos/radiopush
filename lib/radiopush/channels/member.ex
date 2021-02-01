defmodule Radiopush.Channels.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @roles [:owner, :member, :pending, :rejected]

  @primary_key false
  schema "members" do
    belongs_to :user, Radiopush.Accounts.User, primary_key: true
    belongs_to :channel, Radiopush.Channels.Channel, primary_key: true
    field :role, Ecto.Enum, values: @roles

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :channel_id, :role])
    |> validate_required([:user_id, :channel_id, :role])
  end
end
