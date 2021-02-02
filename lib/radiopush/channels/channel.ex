defmodule Radiopush.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}
  alias Radiopush.Channels.{Member, Post}

  schema "channels" do
    field :name, :string
    field :private, :boolean

    many_to_many(:members, User, join_through: Member, on_replace: :delete)
    has_many(:posts, Post)

    timestamps()
  end

  @required_fields [:name]
  @optional_fields [:private]

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def changeset_private(channel, attrs) do
    channel
    |> cast(attrs, [:private])
    |> validate_required([:private])
  end
end
