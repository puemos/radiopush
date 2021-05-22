defmodule Radiopush.Channels.Channel do
  use Radiopush.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id(),
          name: String.t(),
          description: String.t(),
          private: boolean(),
          total_posts: integer() | nil
        }

  schema "channels" do
    belongs_to :owner, User

    field :name, :string
    field :description, :string
    field :private, :boolean, default: true
    field :total_posts, :integer, virtual: true
    field :total_users, :integer, virtual: true

    timestamps()
  end

  @required_fields [:name, :owner_id]
  @optional_fields [:private, :description]

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]{3,21}$/,
      message:
        "Must be between 3-21 characters long, cannot have spaces, underscores are the only special characters allowed."
    )
    |> validate_required(@required_fields)
  end
end
