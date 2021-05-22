defmodule Radiopush.Spotify.Credentials do
  @moduledoc false

  use TypedStruct

  typedstruct do
    field :access_token, String.t(), enforce: true
    field :refresh_token, String.t(), enforce: true
  end

  def new(item) do
    %__MODULE__{
      access_token: item.access_token,
      refresh_token: item.refresh_token
    }
  end
end
