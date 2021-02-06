defmodule Radiopush.ChannelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Radiopush.Channels` context.
  """

  def valid_attrs, do: %{name: "some name"}
  def update_attrs, do: %{name: "some updated name"}
  def invalid_attrs, do: %{name: nil}

  def channel_fixture(owner, attrs \\ %{}) do
    attrs = Enum.into(attrs, valid_attrs())
    {:ok, channel} = Radiopush.Channels.create_channel(owner, attrs)

    channel
  end
end
