defmodule Radiopush.ChannelsTest do
  use Radiopush.DataCase

  alias Radiopush.Channels
  import Radiopush.AccountsFixtures
  import Radiopush.ChannelsFixtures

  describe "channels" do
    alias Radiopush.Channels.Channel

    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} = Channels.create_channel(valid_attrs())
      assert channel.name == "some name"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(invalid_attrs())
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, update_attrs())
      assert channel.name == "some updated name"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, invalid_attrs())
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end

    test "add_channel_member/2 adds members to a channel" do
      channel = channel_fixture()
      user = user_fixture()

      channel =
        Channels.add_channel_member(channel, user.email)
        |> Repo.preload(:members)

      assert Enum.member?(channel.members, user)
    end

    test "remove_channel_member/2 remove members from a channel" do
      channel = channel_fixture()
      user = user_fixture()

      channel =
        Channels.add_channel_member(channel, user.email)
        |> Channels.remove_channel_member(user.email)
        |> Repo.preload(:members)

      assert !Enum.member?(channel.members, user)
    end

    test "list_channels_by_user/1 list users' channels" do
      channel = channel_fixture()
      user = user_fixture()

      channel = Channels.add_channel_member(channel, user.email)

      user_channels = Channels.list_channels_by_user(user)

      assert Enum.member?(user_channels, channel)
    end

    test "add_post_to_channel/3 post on a channel" do
      channel = channel_fixture()
      user = user_fixture()

      body =
        channel
        |> Channels.add_channel_member(user.email)
        |> Channels.add_post_to_channel(user, %{"body" => "some text"})
        |> Channels.get_channel_posts()
        |> List.first()
        |> Map.get(:body)

      assert "some text" = body
    end

    test "add_post_to_channel/3 post on a channel by non-member" do
      channel = channel_fixture()
      user = user_fixture()

      {:error, error} = Channels.add_post_to_channel(channel, user, %{"body" => "some text"})

      assert "unauthorized" = error
    end

    test "get_channel_posts/1 get channel's post history" do
      channel = channel_fixture()
      user = user_fixture()

      posts =
        channel
        |> Channels.add_channel_member(user.email)
        |> Channels.get_channel_posts()

      assert 0 = Enum.count(posts)

      posts =
        channel
        |> Channels.add_post_to_channel(user, %{"body" => "1"})
        |> Channels.add_post_to_channel(user, %{"body" => "2"})
        |> Channels.add_post_to_channel(user, %{"body" => "3"})
        |> Channels.add_post_to_channel(user, %{"body" => "4"})
        |> Channels.get_channel_posts()

      assert 4 = Enum.count(posts)
    end
  end
end
