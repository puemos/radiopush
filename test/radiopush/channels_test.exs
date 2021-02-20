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
      channel = channel_fixture(owner, %{private: false})

      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})

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
      channel = channel_fixture(owner, %{private: false})

      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, update_attrs())
      assert channel.name == "some updated name"
    end

    test "update_channel_private/2 with valid data updates the channel private" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})

      assert {:ok, %Channel{} = channel} =
               Channels.update_channel_private(channel, %{private: true})

      assert channel.private == true
    end

    test "update_channel/2 with invalid data returns error changeset" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})

      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, invalid_attrs())
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "add_member/2 adds members to a channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()

      channel = Channels.add_member(channel, owner, user)

      assert Channels.get_member(channel, user).role == :member
    end

    test "join/2 join a public channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
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
      channel = channel_fixture(owner, %{private: false})

      channel = Channels.join(channel, user)

      assert {:error, "already a member"} == Channels.join(channel, user)
    end

    test "accept_user/2 accept join channel request" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()

      channel =
        channel
        |> Channels.join(user)
        |> Channels.accept_user(owner, user)

      assert Channels.get_member(channel, user).role == :member
    end

    test "accept_user/2 not the owner" do
      owner = user_fixture()
      user = user_fixture()
      channel = channel_fixture(owner, %{private: false})

      channel = Channels.add_member(channel, owner, user)

      assert {:error, "not allowed to manage members"} ==
               Channels.accept_user(channel, user, user)
    end

    test "accept_user/2 user is not pending" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()

      channel = Channels.join(channel, user)

      assert {:error, "user is not pending"} == Channels.accept_user(channel, owner, user)
    end

    test "reject_user/2 reject join channel request" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()

      channel =
        channel
        |> Channels.join(user)
        |> Channels.reject_user(owner, user)

      assert Channels.get_member(channel, user).role == :rejected
    end

    test "reject_user/2 not the owner" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()
      user2 = user_fixture()

      channel = Channels.join(channel, user)

      assert {:error, "not allowed to manage members"} ==
               Channels.reject_user(channel, user, user2)
    end

    test "reject_user/2 user is not pending" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: true})
      user = user_fixture()

      channel = Channels.add_member(channel, owner, user)

      assert {:error, "user is not pending"} = Channels.reject_user(channel, owner, user)
    end

    test "remove_user/2 remove members from a channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()

      channel =
        channel
        |> Channels.join(user)
        |> Channels.remove_user(owner, user)

      assert Channels.get_member(channel, user) == nil
    end

    test "list_channels_by_user/1 list users' channels" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()

      channel = Channels.join(channel, user)

      user_channels = Channels.list_channels_by_user(user)

      assert user_channels == [channel]
    end

    test "new_post/3 post on a channel" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()
      post_attrs = PostsFixtures.valid_attrs()

      posts =
        channel
        |> Channels.join(user)
        |> Channels.new_post(user, post_attrs)
        |> Channels.get_channel_posts()

      assert [post] = posts.entries
      assert post.song == "some song"
    end

    test "new_post/3 post on a channel by non-member" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()
      post_attrs = PostsFixtures.valid_attrs()

      posts = Channels.get_channel_posts(channel)

      assert {:error, "not a member"} = Channels.new_post(channel, user, post_attrs)
      assert posts.entries == []
    end

    test "get_channel_posts/1 get channel's post history" do
      owner = user_fixture()
      channel = channel_fixture(owner, %{private: false})
      user = user_fixture()
      post_attrs = PostsFixtures.valid_attrs()

      posts =
        channel
        |> Channels.join(user)
        |> Channels.new_post(user, post_attrs)
        |> Channels.new_post(user, post_attrs)
        |> Channels.new_post(user, post_attrs)
        |> Channels.new_post(user, post_attrs)
        |> Channels.get_channel_posts()

      assert [post, _, _, _] = posts.entries
      assert post.song == "some song"
    end
  end
end
