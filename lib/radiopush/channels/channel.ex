defmodule Radiopush.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Radiopush.Channels.{Member, Post}

  schema "channels" do
    field :name, :string
    field :private, :boolean, default: true
    field :description, :string

    has_many(:members, Member)
    has_many(:posts, Post)

    timestamps()
  end

  @required_fields [:name]
  @optional_fields [:private, :description]

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def private_changeset(channel, attrs) do
    channel
    |> cast(attrs, [:private])
    |> validate_required([:private])
  end
end
