defmodule Radiopush.Channels.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    belongs_to :user, Radiopush.Accounts.User
    belongs_to :channel, Radiopush.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id, :channel_id])
    |> validate_required([:body, :user_id, :channel_id])
  end
end
