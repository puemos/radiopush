# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

# Faker.start()


defmodule Radiopush.Seeds do
  alias Radiopush.Accounts
  alias Radiopush.Channels

  defp channel_fixture(owner, attr) do
    {:ok, channel} =
      owner
      |> Channels.create_channel(attr)

    channel
  end

  defp user_fixture() do
    name = Faker.Pokemon.En.name() |> String.downcase()
    name_lowercase = name |> String.downcase()

    {:ok, user} =
      %{
        email: "#{name_lowercase}@mail.com",
        nickname: name,
        password: "123123123123"
      }
      |> Accounts.register_user()

    user
  end

  def run() do
    users = Enum.map(Range.new(0, 10), fn _ -> user_fixture() end)

    channels =
      Enum.map(Range.new(0, 10), fn
        i ->
          channel_fixture(Enum.at(users, i), %{
            name: Faker.Food.dish(),
            private: rem(i, 3) == 0
          })
      end)
  end
end

Radiopush.Seeds.run()
