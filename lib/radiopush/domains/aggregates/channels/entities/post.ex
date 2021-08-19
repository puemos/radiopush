defmodule Radiopush.Channels.Post do
  use Radiopush.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}
  alias Radiopush.Channels.{Channel, PostReaction}

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id(),
          user_id: String.t(),
          channel_id: String.t(),
          type: :song,
          song: String.t(),
          album: String.t(),
          musician: String.t(),
          url: String.t(),
          image: String.t(),
          audio_preview: String.t(),
          reactions: nil | list(PostReaction.t()),
          explicit: boolean(),
          tempo: float(),
          duration_ms: float()
        }

  schema "posts" do
    belongs_to :user, User
    belongs_to :channel, Channel
    has_many :reactions, PostReaction

    field :type, Ecto.Enum, values: [:song]
    field :song, :string
    field :album, :string
    field :musician, :string
    field :url, :string
    field :image, :string
    field :audio_preview, :string
    field :explicit, :boolean, default: false
    field :tempo, :float, default: 0.0
    field :duration_ms, :float, default: 0.0

    timestamps()
  end

  @required_fields [:type, :user_id, :channel_id, :url, :musician]
  @optional_fields [:image, :audio_preview, :song, :album, :explicit, :tempo, :duration_ms]

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id, name: "posts_user_id_fkey")
    |> foreign_key_constraint(:channel_id, name: "posts_channel_id_fkey")
  end
end
