defmodule Radiopush.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}
  alias Radiopush.Channels.{Channel, Member}

  schema "channels" do
    field :name, :string

    many_to_many(:members, User, join_through: Member, on_replace: :delete)

    timestamps()
  end

  @required_fields [:name]
  @optional_fields []

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end
end
