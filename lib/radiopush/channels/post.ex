defmodule Radiopush.Channels.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    belongs_to :user, Radiopush.Accounts.User
    belongs_to :channel, Radiopush.Channels.Channel

    field :type, Ecto.Enum, values: [:song, :album]
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
    |> changeset_assoc(attrs)
    |> changeset_data(attrs)
  end

  def changeset_assoc(post, attrs) do
    post
    |> cast(attrs, [:user_id, :channel_id])
    |> validate_required([:user_id, :channel_id])
  end

  def changeset_data(post, attrs) do
    post
    |> cast(attrs, [:type, :song, :album, :musician, :url, :image])
    |> validate_required([:type, :album, :musician, :url, :image])
  end
end
