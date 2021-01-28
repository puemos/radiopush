defmodule Radiopush.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Radiopush.Channels` context.
  """

  def valid_attrs,
    do: %{
      type: :song,
      song: "some song",
      album: "some album",
      musician: "some musician",
      url: "some url",
      image: "some image"
    }

  def invalid_attrs, do: %{}
end
