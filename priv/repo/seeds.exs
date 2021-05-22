alias Radiopush.Cmd.CreateChannel
alias Radiopush.Cmd.CreateUser

alias Radiopush.Context

{:ok, creator} =
  CreateUser.run(
    %Context{},
    %CreateUser.Cmd{
      nickname: Faker.Internet.user_name(),
      email: Faker.Internet.email()
    }
  )

context =
  Context.new(%{
    user: creator,
    credentials: %{access_token: "asd", refresh_token: "asd"}
  })

_ =
  1..30
  |> Enum.map(fn _ ->
    CreateChannel.run(
      context,
      %CreateChannel.Cmd{
        name: Faker.Superhero.name() |> String.replace(" ", ""),
        private: false,
        description: Faker.Lorem.sentence(5..8)
      }
    )
  end)
