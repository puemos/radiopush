defmodule Radiopush.Channels.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    belongs_to :user, Radiopush.Accounts.User
    belongs_to :channel, Radiopush.Channels.Channel
    field :type, :string
    field :song, :string
    field :album, :string
    field :musician, :string
    field :url, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:type, :song, :album, :musician, :url, :image, :user_id, :channel_id])
    |> validate_required([:type, :album, :musician, :url, :image, :user_id, :channel_id])
  end
end
