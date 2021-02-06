ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Radiopush.Repo, :manual)

Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)

Application.put_env(:radiopush, :http_client, HTTPoison.BaseMock)
