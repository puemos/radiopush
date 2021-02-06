# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

Faker.start()

defmodule Radiopush.Seeds do
  alias Radiopush.Accounts
  alias Radiopush.Channels

  defp channel_fixture() do
    {:ok, channel} =
      %{name: Faker.Food.dish(), private: false}
      |> Radiopush.Channels.create_channel()

    channel
  end

  defp user_fixture() do
    {:ok, user} =
      %{
        email: "user#{System.unique_integer()}@example.com",
        password: "123123123123"
      }
      |> Radiopush.Accounts.register_user()

    user
  end

  def run() do
    users = Enum.map(Range.new(0, 10), fn _ -> user_fixture() end)
    channels = Enum.map(Range.new(0, 10), fn _ -> channel_fixture() end)

    Channels.add_channel_owner(Enum.at(channels, 0), Enum.at(users, 0))
    Channels.add_channel_owner(Enum.at(channels, 1), Enum.at(users, 0))
    Channels.add_channel_owner(Enum.at(channels, 2), Enum.at(users, 1))
    Channels.add_channel_owner(Enum.at(channels, 3), Enum.at(users, 1))
    Channels.add_channel_owner(Enum.at(channels, 4), Enum.at(users, 2))
    Channels.add_channel_owner(Enum.at(channels, 5), Enum.at(users, 2))
    Channels.add_channel_owner(Enum.at(channels, 6), Enum.at(users, 3))
    Channels.add_channel_owner(Enum.at(channels, 7), Enum.at(users, 3))
    Channels.add_channel_owner(Enum.at(channels, 8), Enum.at(users, 3))

    Channels.add_channel_member(Enum.at(channels, 0), Enum.at(users, 5))
    Channels.add_channel_member(Enum.at(channels, 1), Enum.at(users, 5))
    Channels.add_channel_member(Enum.at(channels, 2), Enum.at(users, 6))
    Channels.add_channel_member(Enum.at(channels, 3), Enum.at(users, 6))
    Channels.add_channel_member(Enum.at(channels, 4), Enum.at(users, 7))
    Channels.add_channel_member(Enum.at(channels, 5), Enum.at(users, 7))
    Channels.add_channel_member(Enum.at(channels, 6), Enum.at(users, 0))
    Channels.add_channel_member(Enum.at(channels, 7), Enum.at(users, 0))
    Channels.add_channel_member(Enum.at(channels, 8), Enum.at(users, 0))
  end
end

Radiopush.Seeds.run()
