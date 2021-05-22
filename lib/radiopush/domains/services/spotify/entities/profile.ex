defmodule Radiopush.Spotify.Profile do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :nickname, String.t()
    field :email, String.t()
    field :image, String.t()
    field :id, String.t()
  end

  def new(item) do
    %__MODULE__{
      id: item.id,
      nickname: item.nickname,
      email: item.email,
      image: item.image
    }
  end
end
