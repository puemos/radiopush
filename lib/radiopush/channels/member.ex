defmodule Radiopush.Channels.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "members" do
    belongs_to :user, Radiopush.Accounts.User
    belongs_to :channel, Radiopush.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :channel_id])
    |> validate_required([:user_id, :channel_id])
  end
end