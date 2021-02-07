# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

Faker.start()

defmodule Radiopush.Seeds do
  alias Radiopush.Accounts
  alias Radiopush.Channels

  defp channel_fixture(owner) do
    {:ok, channel} =
      %{name: Faker.Food.dish(), private: false}
      |> Radiopush.Channels.create_channel(owner)

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
    channels = Enum.map(Range.new(0, 10), fn
       i -> channel_fixture(Enum.at(users, i), ${private: i % 2 == 0})
      end)


  end
end

Radiopush.Seeds.run()
