defmodule Radiopush.Channels.ChannelUser do
  use Radiopush.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}
  alias Radiopush.Channels.{Channel}

  @type id :: String.t()
  @type t :: %__MODULE__{
          channel_id: Channel.id(),
          user_id: User.id()
        }

  @primary_key false
  schema "channels_users" do
    field :channel_id, :binary_id
    field :user_id, :binary_id

    timestamps()
  end

  @required_fields [:channel_id, :user_id]
  @optional_fields []

  @doc false
  def changeset(channel_user, attrs) do
    channel_user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:channel_id, :user_id], name: :channels_users_pkey)
  end
end
