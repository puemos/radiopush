defmodule Radiopush.Channels.PostReaction do
  use Radiopush.Schema
  import Ecto.Changeset

  alias Radiopush.Accounts.{User}
  alias Radiopush.Channels.{Post}

  @type id :: String.t()
  @type t :: %__MODULE__{
          id: id(),
          user: User,
          post: Post,
          emoji: String.t()
        }

  schema "post_reactions" do
    belongs_to :user, User
    belongs_to :post, Post
    field :emoji, :string

    timestamps()
  end

  @required_fields [:emoji, :post_id, :user_id]
  @optional_fields []

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:emoji, :user_id, :post_id], name: "post_reactions_pkey")
    |> foreign_key_constraint(:user_id, name: "post_reactions_user_id_fkey")
    |> foreign_key_constraint(:post_id, name: "post_reactions_post_id_fkey")
  end
end
