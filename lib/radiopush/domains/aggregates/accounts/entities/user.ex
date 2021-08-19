defmodule Radiopush.Accounts.User do
  use Radiopush.Schema
  import Ecto.Changeset

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id(),
          email: String.t(),
          nickname: String.t(),
          image: String.t(),
          spotify_id: String.t()
        }

  schema "users" do
    field :email, :string
    field :nickname, :string
    field :image, :string
    field :spotify_id, :string

    timestamps()
  end

  @required_fields [:email, :nickname, :spotify_id]
  @optional_fields [:image]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:email], name: "users_email_index")
  end

  def new(item) do
    %__MODULE__{
      email: item.email,
      id: item.id,
      nickname: item.nickname,
      image: item.image,
      spotify_id: item.spotify_id,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
  end
end
