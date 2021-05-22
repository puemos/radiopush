ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Radiopush.Repo, :manual)

Mox.defmock(Radiopush.Spotify.ClientMock, for: Radiopush.Spotify.Client.Impl)
Application.put_env(:radiopush, :spotify_client, Radiopush.Spotify.ClientMock)
