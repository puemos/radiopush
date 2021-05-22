defmodule Radiopush.Context do
  @moduledoc false
  use TypedStruct

  alias Radiopush.Accounts.User
  alias Radiopush.Spotify.Credentials

  typedstruct do
    field :user, User.t()
    field :credentials, Credentials.t()
  end

  def new(item) do
    %__MODULE__{
      user: User.new(item.user),
      credentials: Credentials.new(item.credentials)
    }
  end
end
