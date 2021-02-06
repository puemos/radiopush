defmodule Radiopush.ChannelsTest do
  use Radiopush.DataCase

  alias Radiopush.Channels
  import Radiopush.AccountsFixtures
  import Radiopush.ChannelsFixtures
  alias Radiopush.PostsFixtures

  describe "channels" do
    alias Radiopush.Channels.Channel

    test "list_channels/0 returns all channels" do
      owner = user_fixture()
      channel = channel_fixture(owner)

      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      owner = user_fixture()
      channel = channel_fixture(owner)

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
      owner = user_fixture()
      channel = channel_fixture(owner)

      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, update_attrs())
      assert channel.name == "some updated name"
    end

    test "update_channel_private/2 with valid data updates the channel private" do
      owner = user_fixture()
      channel = channel_fixture(owner)

      assert {:ok, %Channel{} = channel} =
               Channels.update_channel_private(channel, %{private: true})

      assert channel.private == true
    end

    test "update_channel/2 with invalid data returns error changeset" do
      owner = user_fixture()
      channel = channel_fixture(owner)

      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, invalid_attrs())
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      owner = user_fixture()
      channel = channel_fixture(owner)
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "add_member/2 adds members to a channel" do
      owner = user_fixture()
      channel = channel_fixture(owner)
      user = user_fixture()

      channel = Channels.add_member(channel, owner, user)

      assert Channels.get_member(channel, user)
    end

    test "join/2 join a public channel" do
      owner = user_fixture()
      channel = channel_fixture(owner)
      user = user_fixture()

      member =
        channel
        |> Channels.join(user)
        |> Channels.get_member(user)

      assert member.role == :member
    end

    test "join/2 join a private channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()

      member =
        channel
        |> Channels.join(user)
        |> Channels.get_member(user)

      assert member.role == :pending
    end

    test "join/2 already a member" do
      owner = user_fixture()
      user = user_fixture()
      channel = channel_fixture(owner)

      channel = Channels.join(channel, user)

      assert {:error, "already a member"} = Channels.join(channel, user)
    end

    test "accept_pending_member/2 accept join channel request" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()

      channel =
        channel
        |> Channels.join(user)
        |> Channels.accept_pending_member(owner, user)

      assert Channels.get_member(channel, user).role == :member
    end

    # test "accept_pending_member/2 not the owner" do
    #   owner = user_fixture()
    #   user = user_fixture()
    #   channel = channel_fixture(owner)

    #   Channels.add_member(channel, owner, user, :pending)

    #   assert {:error, "not the owner"} = Channels.accept_pending_member(channel, user, user)
    # end

    # test "accept_pending_member/2 user is not pending" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()

    #   assert {:error, "user is not pending"} =
    #            Channels.accept_pending_member(channel, owner, user)
    # end

    # test "reject_pending_member/2 reject join channel request" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()

    #   channel =
    #     channel
    #     |> Channels.join(owner, user)
    #     |> Channels.reject_pending_member(owner, user)

    #   assert !Channels.get_member(channel, user)
    #   assert Channels.is_channel_rejected?(channel, user)
    # end

    # test "reject_pending_member/2 not the owner" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()
    #   user2 = user_fixture()

    #   channel =
    #     channel
    #     |> Channels.join(user)

    #   assert {:error, "not the owner"} = Channels.reject_pending_member(channel, user, user2)
    # end

    # test "reject_pending_member/2 user is not pending" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   owner = user_fixture()
    #   user = user_fixture()

    #   channel =
    #     channel
    #     |> Channels.add_channel_owner(owner)

    #   assert {:error, "user is not pending"} =
    #            Channels.reject_pending_member(channel, owner, user)
    # end

    # test "remove_member/2 remove members from a channel" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()

    #   channel = Channels.add_member(channel, user)
    #   assert Channels.get_member(channel, user)

    #   Channels.remove_member(channel, user)
    #   assert !Channels.get_member(channel, user)
    # end

    # test "list_channels_by_user/1 list users' channels" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()

    #   channel = Channels.add_member(channel, user)

    #   user_channels = Channels.list_channels_by_user(user)

    #   assert Enum.member?(user_channels, channel)
    # end

    # test "add_post_to_channel/3 post on a channel" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()
    #   post_attrs = PostsFixtures.valid_attrs()

    #   song =
    #     channel
    #     |> Channels.add_member(user)
    #     |> Channels.add_post_to_channel(user, post_attrs)
    #     |> Channels.get_channel_posts()
    #     |> List.first()
    #     |> Map.get(:song)

    #   assert "some song" = song
    # end

    # test "add_post_to_channel/3 post on a channel by non-member" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()
    #   post_attrs = PostsFixtures.valid_attrs()

    #   {:error, error} = Channels.add_post_to_channel(channel, user, post_attrs)

    #   assert "unauthorized" = error
    # end

    # test "get_channel_posts/1 get channel's post history" do
    #   owner = user_fixture()
    #   channel = channel_fixture(owner)
    #   user = user_fixture()
    #   post_attrs = PostsFixtures.valid_attrs()

    #   posts =
    #     channel
    #     |> Channels.add_member(user)
    #     |> Channels.get_channel_posts()

    #   assert 0 = Enum.count(posts)

    #   posts =
    #     channel
    #     |> Channels.add_post_to_channel(user, post_attrs)
    #     |> Channels.add_post_to_channel(user, post_attrs)
    #     |> Channels.add_post_to_channel(user, post_attrs)
    #     |> Channels.add_post_to_channel(user, post_attrs)
    #     |> Channels.get_channel_posts()

    #   assert 4 = Enum.count(posts)
    # end
  end
end
